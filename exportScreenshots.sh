TEST_RESULT_DIR="/Users/$(whoami)/Library/Developer/Xcode/DerivedData/SchoolPower-aadzsnwenztavfdcnlugnxigfvcq/Logs/Test/"
SCREENSHOT_OUTPUT_DIR="./screenshots/"

mkdir -p $SCREENSHOT_OUTPUT_DIR
xcparse screenshots --os --model --test-plan-config $TEST_RESULT_DIR/$(ls $TEST_RESULT_DIR | tail -n 1) $SCREENSHOT_OUTPUT_DIR
