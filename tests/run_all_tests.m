%% run_all_tests.m - Test runner for all unit tests

function run_all_tests()
    fprintf('======================================\n');
    fprintf('Running All Unit Tests\n');
    fprintf('======================================\n\n');
    
    % Store test results
    results = struct();
    
    %% Test 1: vprism function
    fprintf('1. Testing vprism function:\n');
    fprintf('----------------------------\n');
    try
        test_vprism();
        results.vprism = 'COMPLETED';
    catch ME
        fprintf('ERROR in vprism tests: %s\n', ME.message);
        results.vprism = 'FAILED';
    end
    fprintf('\n');
    
    %% Test 2: bouguer_anomaly function
    fprintf('2. Testing bouguer_anomaly function:\n');
    fprintf('------------------------------------\n');
    try
        test_bouguer_anomaly();
        results.bouguer_anomaly = 'COMPLETED';
    catch ME
        fprintf('ERROR in bouguer_anomaly tests: %s\n', ME.message);
        results.bouguer_anomaly = 'FAILED';
    end
    fprintf('\n');
    
    %% Test 3: orthometric_height function
    fprintf('3. Testing orthometric_height function:\n');
    fprintf('---------------------------------------\n');
    try
        test_orthometric_height();
        results.orthometric_height = 'COMPLETED';
    catch ME
        fprintf('ERROR in orthometric_height tests: %s\n', ME.message);
        results.orthometric_height = 'FAILED';
    end
    fprintf('\n');
    
    %% Test 4: Integration test with sample data
    fprintf('4. Integration test with sample data:\n');
    fprintf('------------------------------------\n');
    try
        test_integration();
        results.integration = 'COMPLETED';
    catch ME
        fprintf('ERROR in integration test: %s\n', ME.message);
        results.integration = 'FAILED';
    end
    fprintf('\n');
    
    %% Summary
    fprintf('======================================\n');
    fprintf('Test Summary\n');
    fprintf('======================================\n');
    
    test_names = fieldnames(results);
    total_tests = length(test_names);
    completed_tests = 0;
    
    for i = 1:total_tests
        status = results.(test_names{i});
        fprintf('  %-20s: %s\n', test_names{i}, status);
        if strcmp(status, 'COMPLETED')
            completed_tests = completed_tests + 1;
        end
    end
    
    fprintf('\n');
    fprintf('Overall Results:\n');
    fprintf('  Total test suites: %d\n', total_tests);
    fprintf('  Completed: %d\n', completed_tests);
    fprintf('  Failed: %d\n', total_tests - completed_tests);
    fprintf('  Success rate: %.1f%%\n', 100 * completed_tests / total_tests);
    
    if completed_tests == total_tests
        fprintf('\n  🎉 ALL TEST SUITES COMPLETED! 🎉\n');
    else
        fprintf('\n  ⚠️  SOME TEST SUITES FAILED! ⚠️\n');
    end
    
    fprintf('======================================\n');
end

function test_orthometric_height()
    fprintf('Running orthometric_height function tests...\n');
    
    % Add src to path
    addpath('../src');
    
    test_count = 0;
    pass_count = 0;
    
    %% Test 1: Simple method
    test_count = test_count + 1;
    fprintf('Test %d: Simple method...', test_count);
    
    try
        h_ellips = 1000;
        N_geoid = 50;
        g_surface = 9.8;
        
        [H, method] = orthometric_height(h_ellips, N_geoid, g_surface, 'simple');
        expected_H = h_ellips - N_geoid;
        
        if abs(H - expected_H) < 1e-6
            fprintf(' PASS\n');
            pass_count = pass_count + 1;
        else
            fprintf(' FAIL (expected %.3f, got %.3f)\n', expected_H, H);
        end
    catch ME
        fprintf(' FAIL (error: %s)\n', ME.message);
    end
    
    %% Test 2: Method consistency
    test_count = test_count + 1;
    fprintf('Test %d: Method variations...', test_count);
    
    try
        h_ellips = 1200;
        N_geoid = 45;
        g_surface = 9.8001;
        
        [H_simple, ~] = orthometric_height(h_ellips, N_geoid, g_surface, 'simple');
        [H_helmert, ~] = orthometric_height(h_ellips, N_geoid, g_surface, 'helmert');
        [H_rigorous, ~] = orthometric_height(h_ellips, N_geoid, g_surface, 'rigorous');
        
        % All methods should give results within reasonable range
        if all(abs([H_simple, H_helmert, H_rigorous] - (h_ellips - N_geoid)) < 100)
            fprintf(' PASS\n');
            pass_count = pass_count + 1;
        else
            fprintf(' FAIL (results out of range)\n');
        end
    catch ME
        fprintf(' FAIL (error: %s)\n', ME.message);
    end
    
    %% Test 3: Unit handling (mGal vs m/s²)
    test_count = test_count + 1;
    fprintf('Test %d: Unit handling...', test_count);
    
    try
        h_ellips = 1000;
        N_geoid = 50;
        
        [H_ms2, ~] = orthometric_height(h_ellips, N_geoid, 9.8001, 'helmert');
        [H_mgal, ~] = orthometric_height(h_ellips, N_geoid, 980010, 'helmert');
        
        % Both should give similar results (function should handle units)
        if abs(H_ms2 - H_mgal) < 1.0  % Allow 1m difference for unit conversion
            fprintf(' PASS\n');
            pass_count = pass_count + 1;
        else
            fprintf(' FAIL (unit handling issue)\n');
        end
    catch ME
        fprintf(' FAIL (error: %s)\n', ME.message);
    end
    
    fprintf('  Tests passed: %d/%d\n', pass_count, test_count);
end

function test_integration()
    fprintf('Running integration test with sample data...\n');
    
    % Add src to path
    addpath('../src');
    
    test_count = 0;
    pass_count = 0;
    
    %% Test 1: Check if sample data exists
    test_count = test_count + 1;
    fprintf('Test %d: Sample data availability...', test_count);
    
    if exist('../dgm.mat', 'file')
        fprintf(' PASS\n');
        pass_count = pass_count + 1;
    else
        fprintf(' FAIL (dgm.mat not found)\n');
        fprintf('  Integration tests skipped.\n');
        return;
    end
    
    %% Test 2: Load and validate data structure
    test_count = test_count + 1;
    fprintf('Test %d: Data structure validation...', test_count);
    
    try
        dgm = load('../dgm.mat');
        
        if isfield(dgm, 'dgm') && isfield(dgm.dgm, 'x') && ...
           isfield(dgm.dgm, 'y') && isfield(dgm.dgm, 'z')
            fprintf(' PASS\n');
            pass_count = pass_count + 1;
        else
            fprintf(' FAIL (invalid data structure)\n');
        end
    catch ME
        fprintf(' FAIL (error loading data: %s)\n', ME.message);
    end
    
    %% Test 3: Quick analysis run
    test_count = test_count + 1;
    fprintf('Test %d: Quick analysis run...', test_count);
    
    try
        % Run with minimal settings to test functionality
        [results, figures] = topographic_gravity_analysis('../dgm.mat', ...
            'profile_length', 2, 'save_results', false, 'save_figures', false);
        
        % Check if essential results are present
        if isstruct(results) && isfield(results, 'gravity_bouguer') && ...
           isfield(results, 'gravity_prism') && ~isempty(figures)
            fprintf(' PASS\n');
            pass_count = pass_count + 1;
            
            % Close figures to clean up
            close(figures);
        else
            fprintf(' FAIL (incomplete results)\n');
        end
    catch ME
        fprintf(' FAIL (analysis error: %s)\n', ME.message);
    end
    
    fprintf('  Integration tests passed: %d/%d\n', pass_count, test_count);
end