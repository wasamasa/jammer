;; -*- lexical-binding: t -*-

(require 'buttercup)
(require 'jammer)

(describe "The `jammer' function"
  (it "should call `jammer-repeat' for the 'repeat value of `jammer-type'"
    (spy-on 'jammer-repeat)
    (let ((jammer-type 'repeat))
      (jammer))
    (expect 'jammer-repeat
            :to-have-been-called))

  (it "should call `jammer-constant' for the 'constant value of `jammer-type'"
    (spy-on 'jammer-constant)
    (let ((jammer-type 'constant))
      (jammer))
    (expect 'jammer-constant
            :to-have-been-called))

  (it "should call `jammer-random' for the 'random value of `jammer-type'"
    (spy-on 'jammer-random)
    (let ((jammer-type 'random))
      (jammer))
    (expect 'jammer-random
            :to-have-been-called))

  (it "should not do anything for an unknown type of `jammer-type' and return nil."
    (let ((jammer-type 'unknown))
      (expect (jammer)
              :not :to-be-truthy))))

(describe "The `jammer-block-list' variable"
  (let (jammer-type)
    (before-each
      (setq jammer-type 'constant)
      (spy-on 'jammer-delay))

    (it "should trigger a delay when `jammer-block-type' is 'whitelist and `this-command' is not a member of `jammer-block-list'."
      (let ((jammer-block-type 'whitelist)
            (jammer-block-list '())
            (this-command 'unknown))
        (jammer)
        (expect 'jammer-delay
                :to-have-been-called)))

    (it "should not trigger a delay when `jammer-block-type' is 'whitelist and `this-command' is a member of `jammer-block-list'."
      (let ((jammer-block-type 'whitelist)
            (jammer-block-list '(ignore))
            (this-command 'ignore))
        (jammer)
        (expect 'jammer-delay
                :not :to-have-been-called)))

    (it "should not trigger a delay when `jammer-block-type' is 'blacklist and `this-command' is not a member of `jammer-block-list'."
      (let ((jammer-block-type 'blacklist)
            (jammer-block-list '())
            (this-command 'unknown))
        (jammer)
        (expect 'jammer-delay
                :not :to-have-been-called)))

    (it "should not trigger a delay when `jammer-block-type' is 'blacklist and `this-command' is a member of `jammer-block-list'."
      (let ((jammer-block-type 'blacklist)
            (jammer-block-list '(ignore))
            (this-command 'ignore))
        (jammer)
        (expect 'jammer-delay
                :to-have-been-called)))))

(describe "The `jammer-repeat' function"
  (let (jammer-repeat-state
        jammer-repeat-allowed-repetitions)
    (before-each
      (setq jammer-repeat-allowed-repetitions 3)
      (spy-on 'this-command-keys-vector
              :and-return-value [42])
      (spy-on 'jammer-delay))

    (it "should not trigger a delay when the time window was missed."
      (setq jammer-repeat-state (vector [42] 3 0))
      (jammer-repeat)
      (expect 'jammer-delay
              :not :to-have-been-called))

    (it "should not trigger a delay when too little repetitions happened."
      (setq jammer-repeat-state (vector [42] 0 (float-time)))
      (jammer-repeat)
      (expect 'jammer-delay
              :not :to-have-been-called))

    (it "should trigger a delay when the time window was hit and enough repetitions did happen."
      (setq jammer-repeat-state (vector [42] 3 (float-time)))
      (jammer-repeat)
      (expect 'jammer-delay
              :to-have-been-called))))

(describe "The `jammer-repeat-state' variable"
  (let (jammer-repeat-state
        jammer-repeat-allowed-repetitions)
    (before-each
      (spy-on 'this-command-keys-vector
              :and-return-value [42])
      (spy-on 'jammer-delay)
      (setq jammer-repeat-allowed-repetitions 0))

    (it "should reset the counter on using a command different from the last recorded one."
      (setq jammer-repeat-state (vector [] 1 (float-time)))
      (jammer-repeat)
      (expect (aref jammer-repeat-state 1)
              :to-equal 0))

    (it "should reset the counter on missing the time window."
      (setq jammer-repeat-state (vector [42] 1 0))
      (jammer-repeat)
      (expect (aref jammer-repeat-state 1)
              :to-equal 0))

    (it "should increment the counter on using the same command as the last recorded one and hitting the time window."
      (setq jammer-repeat-state (vector [42] 1 (float-time)))
      (jammer-repeat)
      (expect (aref jammer-repeat-state 1)
              :to-equal 2))))

(describe "The `jammer-repeat-delay' function"
  (let (jammer-repeat-state
        jammer-repeat-allowed-repetitions)
    (before-each
      (spy-on 'this-command-keys-vector
              :and-return-value [])
      (setq jammer-repeat-state (vector [] 5 (float-time))
            jammer-repeat-allowed-repetitions 0))

    (it "should be the value of `jammer-repeat-delay' for the 'constant type."
      (expect (jammer-repeat-delay 'constant)
              :to-equal jammer-repeat-delay))

    (it "should be the value of `jammer-repeat-delay' times the repetition count for the 'linear type"
      (expect (jammer-repeat-delay 'linear)
             :to-equal (* 5 jammer-repeat-delay)))

    (it "should be the value of `jammer-repeat-delay' times the repetition count squared for the 'quadratic type"
      (expect (jammer-repeat-delay 'quadratic)
              :to-equal (* 25 jammer-repeat-delay)))

    (it "should return a delay of zero for unknown types otherwise"
      (expect (jammer-repeat-delay 'unknown)
              :to-equal 0))))

(describe "The `jammer-constant' function"
  (it "calls `jammer-delay' with the value of `jammer-constant-delay'"
    (spy-on 'jammer-delay)
    (jammer-constant)
    (expect 'jammer-delay
            :to-have-been-called-with jammer-constant-delay)))

(xdescribe "The `jammer-random' function"
  (xit "cannot be tested meaningfully as it's like `jammer-constant', but relies on the PRNG"))
