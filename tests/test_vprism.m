%% test_vprism.m - Unit tests for vprism function
% Tests the rectangular prism gravitational potential calculation

function test_vprism()
    fprintf('Running vprism function tests...\n');
    
    % Add src to path
    addpath('../src');
    
    % Test counter
    test_count = 0;
    pass_count = 0;
    
    %% Test 1: Zero potential for zero-size prism
    test_count = test_count + 1;
    fprintf('Test %d: Zero-size prism...', test_count);
    
    v = vprism(0, 0, 0, 0, 0, 0);
    if abs(v) < 1e-10
        fprintf(' PASS\n');
        pass_count = pass_count + 1;
    else
        fprintf(' FAIL (expected ~0, got %.6e)\n', v);
    end
    
    %% Test 2: Symmetry test
    test_count = test_count + 1;
    fprintf('Test %d: Symmetry...', test_count);
    
    v1 = vprism(-1, 1, -1, 1, 0, 1);
    v2 = vprism(-1, 1, -1, 1, -1, 0);  % Same prism, shifted
    
    if abs(v1 - v2) < 1e-10
        fprintf(' PASS\n');
        pass_count = pass_count + 1;
    else
        fprintf(' FAIL (v1=%.6e, v2=%.6e, diff=%.6e)\n', v1, v2, abs(v1-v2));
    end
    
    %% Test 3: Sign consistency
    test_count = test_count + 1;
    fprintf('Test %d: Sign consistency...', test_count);
    
    v_pos = vprism(1, 2, 1, 2, 1, 2);   % All positive
    v_neg = vprism(-2, -1, -2, -1, -2, -1); % All negative
    
    if (v_pos > 0) && (v_neg < 0)
        fprintf(' PASS\n');
        pass_count = pass_count + 1;
    else
        fprintf(' FAIL (v_pos=%.6e, v_neg=%.6e)\n', v_pos, v_neg);
    end
    
    %% Test 4: Dimensional consistency 
    test_count = test_count + 1;
    fprintf('Test %d: Dimensional scaling...', test_count);
    
    % Doubling all dimensions should scale potential by factor of 8
    v_small = vprism(-1, 1, -1, 1, 0, 1);
    v_large = vprism(-2, 2, -2, 2, 0, 2);
    
    scaling_factor = v_large / v_small;
    expected_factor = 8.0;  % 2^3 for volume scaling
    
    if abs(scaling_factor - expected_factor) < 0.1
        fprintf(' PASS\n');
        pass_count = pass_count + 1;
    else
        fprintf(' FAIL (expected factor=%.1f, got=%.3f)\n', expected_factor, scaling_factor);
    end
    
    %% Test 5: Array input handling
    test_count = test_count + 1;
    fprintf('Test %d: Array inputs...', test_count);
    
    try
        x1 = [-1, -0.5];
        x2 = [1, 0.5];
        v_array = vprism(x1, x2, -1, 1, 0, 1);
        
        if length(v_array) == 2 && all(isfinite(v_array))
            fprintf(' PASS\n');
            pass_count = pass_count + 1;
        else
            fprintf(' FAIL (array handling issue)\n');
        end
    catch ME
        fprintf(' FAIL (error: %s)\n', ME.message);
    end
    
    %% Summary
    fprintf('\nTest Summary:\n');
    fprintf('  Tests run: %d\n', test_count);
    fprintf('  Tests passed: %d\n', pass_count);
    fprintf('  Tests failed: %d\n', test_count - pass_count);
    fprintf('  Success rate: %.1f%%\n', 100 * pass_count / test_count);
    
    if pass_count == test_count
        fprintf('  All tests PASSED!\n');
    else
        fprintf('  Some tests FAILED!\n');
    end
end