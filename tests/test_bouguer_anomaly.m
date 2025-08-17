%% test_bouguer_anomaly.m - Unit tests for bouguer_anomaly function

function test_bouguer_anomaly()
    fprintf('Running bouguer_anomaly function tests...\n');
    
    % Add src to path
    addpath('../src');
    
    % Test counter
    test_count = 0;
    pass_count = 0;
    
    %% Test 1: Basic calculation with realistic values
    test_count = test_count + 1;
    fprintf('Test %d: Basic calculation...', test_count);
    
    try
        % Typical values for a mountainous region
        grav_obs = 981000;  % mGal
        latitude = 45.0;    % degrees
        height = 1000;      % m
        density = 2670;     % kg/m³
        
        anomaly = bouguer_anomaly(grav_obs, latitude, height, density);
        
        % Should be a reasonable anomaly value (typically -200 to +200 mGal)
        if abs(anomaly) < 500 && isfinite(anomaly)
            fprintf(' PASS (anomaly = %.2f mGal)\n', anomaly);
            pass_count = pass_count + 1;
        else
            fprintf(' FAIL (unreasonable anomaly = %.2f mGal)\n', anomaly);
        end
    catch ME
        fprintf(' FAIL (error: %s)\n', ME.message);
    end
    
    %% Test 2: Sea level calculation
    test_count = test_count + 1;
    fprintf('Test %d: Sea level reference...', test_count);
    
    try
        grav_obs = 981000;
        latitude = 45.0;
        height = 0;  % Sea level
        
        anomaly = bouguer_anomaly(grav_obs, latitude, height);
        
        % At sea level, anomaly should be close to difference between
        % observed and normal gravity
        if abs(anomaly) < 100  % Should be small correction
            fprintf(' PASS (sea level anomaly = %.2f mGal)\n', anomaly);
            pass_count = pass_count + 1;
        else
            fprintf(' FAIL (large sea level anomaly = %.2f mGal)\n', anomaly);
        end
    catch ME
        fprintf(' FAIL (error: %s)\n', ME.message);
    end
    
    %% Test 3: Latitude sensitivity
    test_count = test_count + 1;
    fprintf('Test %d: Latitude effects...', test_count);
    
    try
        grav_obs = 981000;
        height = 500;
        
        anomaly_equator = bouguer_anomaly(grav_obs, 0, height);
        anomaly_pole = bouguer_anomaly(grav_obs, 90, height);
        
        % Normal gravity is higher at poles, so difference should be significant
        diff = abs(anomaly_pole - anomaly_equator);
        if diff > 100  % Should be substantial difference
            fprintf(' PASS (latitude effect = %.1f mGal)\n', diff);
            pass_count = pass_count + 1;
        else
            fprintf(' FAIL (small latitude effect = %.1f mGal)\n', diff);
        end
    catch ME
        fprintf(' FAIL (error: %s)\n', ME.message);
    end
    
    %% Test 4: Density variation
    test_count = test_count + 1;
    fprintf('Test %d: Density effects...', test_count);
    
    try
        grav_obs = 981000;
        latitude = 45.0;
        height = 1000;
        
        anomaly_low = bouguer_anomaly(grav_obs, latitude, height, 2000);
        anomaly_high = bouguer_anomaly(grav_obs, latitude, height, 3000);
        
        % Higher density should give more negative Bouguer correction
        if anomaly_high < anomaly_low
            fprintf(' PASS (density effect correct)\n');
            pass_count = pass_count + 1;
        else
            fprintf(' FAIL (wrong density effect)\n');
        end
    catch ME
        fprintf(' FAIL (error: %s)\n', ME.message);
    end
    
    %% Test 5: Unit consistency (m/s² vs mGal)
    test_count = test_count + 1;
    fprintf('Test %d: Unit consistency...', test_count);
    
    try
        latitude = 45.0;
        height = 1000;
        density = 2670;
        
        % Test with mGal input
        grav_mgal = 981000;
        anomaly_mgal = bouguer_anomaly(grav_mgal, latitude, height, density);
        
        % Test with m/s² input  
        grav_ms2 = 9.81;
        anomaly_ms2 = bouguer_anomaly(grav_ms2, latitude, height, density);
        
        % Both should give reasonable results (different scales)
        if abs(anomaly_mgal) > 10 && abs(anomaly_ms2) < 1
            fprintf(' PASS (unit handling correct)\n');
            pass_count = pass_count + 1;
        else
            fprintf(' FAIL (unit handling issue)\n');
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