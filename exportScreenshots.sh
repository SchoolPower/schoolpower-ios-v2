if [ -d "$(cat .testLogDir 2> /dev/null)" ]; then
	TEST_RESULT_DIR=$(cat .testLogDir)
	echo "Found valid cashed test log directory: $TEST_RESULT_DIR"
else
	echo "Valid cashed test log directory not found, running xcodebuild..."
	cd SchoolPower
	source getBuildDir.sh
	cd ..    
	TEST_RESULT_DIR="$CONFIGURATION_BUILD_DIR/Logs/Test"
	echo $TEST_RESULT_DIR > .testLogDir
	echo "Cached test log directory in .testLogDir: $TEST_RESULT_DIR"	
fi

SCREENSHOT_OUTPUT_DIR="./screenshots/"

mkdir -p $SCREENSHOT_OUTPUT_DIR
xcparse screenshots --os --model --test-plan-config $TEST_RESULT_DIR/$(ls $TEST_RESULT_DIR | tail -n 1) $SCREENSHOT_OUTPUT_DIR
