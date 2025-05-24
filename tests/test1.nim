import unittest

import wisp
test "correct welcome":
  check getWelcomeMessage() == "Hello, World!"
