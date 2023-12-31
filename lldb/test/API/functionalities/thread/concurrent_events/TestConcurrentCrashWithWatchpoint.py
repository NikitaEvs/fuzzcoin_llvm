from lldbsuite.test.decorators import *
from lldbsuite.test.concurrent_base import ConcurrentEventsBase
from lldbsuite.test.lldbtest import TestBase


@skipIfWindows
class ConcurrentCrashWithWatchpoint(ConcurrentEventsBase):
    # Atomic sequences are not supported yet for MIPS in LLDB.
    @skipIf(triple="^mips")
    @add_test_categories(["watchpoint"])
    def test(self):
        """Test a thread that crashes while another thread hits a watchpoint."""
        self.build()
        self.do_thread_actions(num_crash_threads=1, num_watchpoint_threads=1)
