;;; ***************************
;;; * DEFTEMPLATES & DEFFACTS *
;;; ***************************

(deftemplate UI-state
   (slot display (default none))
   (slot fact-name (default none))
   (slot response (default none))
   (multislot valid-answers)
   (slot state (default middle)))

(deftemplate state-list
   (slot current)
   (multislot sequence))

(deffacts startup
   (state-list))

;;;***************
;;;* QUERY RULES *
;;;***************

(defrule system-start ""
  =>
  (assert (UI-state (display welcomeMessage)
                    (valid-answers welcomeAnswer)
                    (fact-name start))))

(defrule system-banner  ""
  (start welcomeAnswer)
  =>
  (assert (UI-state (display genderQuestion)
                    (valid-answers Male Female)
                    (fact-name gender))))

(defrule question-male ""
  (gender Male)
  =>
  (assert (UI-state (display questionMale)
                    (valid-answers Dad Brother Uncle Co-worker Father-in-law)
                    (fact-name person))))

(defrule question-dad ""
  (person Dad)
  =>
  (assert (UI-state (display questionDad)
                    (valid-answers Tie Tools Mug Grill)
                    (fact-name gift))))

(defrule question-tie ""
  (gift Tie)
  =>
  (assert (UI-state (display questionTie)
                    (valid-answers MoreThan75 LessThan75)
                    (fact-name ties-number))))

(defrule question-power-tools ""
  (gift Tools)
  =>
  (assert (UI-state (display questionTools)
                    (valid-answers Yes NoTools)
                    (fact-name response-tools))))

(defrule question-mug ""
  (gift Mug)
  =>
  (assert (UI-state (display questionMug)
                    (valid-answers YesMug NoMug)
                    (fact-name response-mug))))

(defrule question-grill ""
  (gift Grill)
  =>
  (assert (UI-state (display questionGrill)
                    (valid-answers YesGrill NoGrill)
                    (fact-name response-grill))))

(defrule question-brother ""
  (person Brother)
  =>
  (assert (UI-state
           (valid-answers Younger Older)
           (fact-name brother-age))))

(defrule question-younger ""
  (brother-age Younger)
  =>
  (assert (UI-state (display questionYoungerBrother)
                    (valid-answers YesYoungerBrother NoBrother)
                    (fact-name response-you-picked))))

(defrule question-older ""
  (brother-age Older)
  =>
  (assert (UI-state (display questionOlderBrother)
                    (valid-answers YesOlderBrother NoBrother)
                    (fact-name response-he-picked))))

(defrule question-crazy-uncle-charlie ""
  (person Uncle)
  =>
  (assert (UI-state (display questionUncle)
                    (valid-answers LastChristmasUncle UncleThanksGiving UncleLastWeek )
                    (fact-name uncle-when))))

(defrule question-co-worker-male ""
  (gender Male)
  (person Co-worker)
  =>
  (assert (UI-state (display questionCoWorkerMale)
                    (valid-answers Yes No)
                    (fact-name boss))))

(defrule question-co-worker-male-yes ""
  (boss Yes)
  =>
  (assert (UI-state (display questionCoWorkerMaleYes)
                    (valid-answers Yes No)
                    (fact-name like-boss))))

(defrule question-female ""
  (gender Female)
  =>
  (assert (UI-state (display questionFemale)
                    (valid-answers Wife Girlfriend Mom Mother Sister Co-worker)
                    (fact-name person))))

(defrule question-girlfriend ""
  (person Girlfriend)
  =>
  (assert (UI-state (display questionBrewersFan)
                    (valid-answers Yes NotYet)
                    (fact-name girlfriend-brewers))))

(defrule question-wife ""
  (person Wife)
  =>
  (assert (UI-state (display questionBrewersFan)
                    (valid-answers Yes NotYet)
                    (fact-name wife-brewers))))

(defrule question-wife-no ""
  (wife-brewers NotYet)
  =>
  (assert (UI-state (display questionWifeNo)
                    (valid-answers Yes No)
                    (fact-name wife-clothes))))

(defrule question-wife-no-yes ""
  (wife-clothes Yes)
  =>
  (assert (UI-state (display questionWifeNoYes)
                    (valid-answers Size32 NotChance)
                    (fact-name wife-size))))

(defrule question-mom ""
  (person Mom)
  =>
  (assert (UI-state (display questionBrewersFan)
                    (valid-answers Yes NoBrewserFanMom)
                    (fact-name mom-brewers))))

(defrule question-mom-no ""
  (or  (mom-brewers NoBrewserFanMom)
  (mother-in-law-choice KeepThinking))
  =>
  (assert (UI-state (display questionMomNo)
                    (valid-answers FunOut QualityTime FoodAndDrink HolidayOrnaments)
                    (fact-name mom-gift))))

(defrule question-mother ""
  (person Mother)
  =>
  (assert (UI-state (display questionMother)
                    (valid-answers FruitCake Home Sweater Poster)
                    (fact-name mother-in-law-gift))))

(defrule question-mother-cake ""
  (mother-in-law-gift FruitCake)
  =>
  (assert (UI-state (display questionMotherCake)
           (valid-answers Next)
           (fact-name mother-com))))

(defrule question-mother-home ""
  (mother-in-law-gift Home)
  =>
  (assert (UI-state (display questionMotherHome)
            (valid-answers Next)
           (fact-name mother-com))))

(defrule question-mother-sweater ""
  (mother-in-law-gift Sweater)
  =>
  (assert (UI-state (display questionMotherSweater)
           (valid-answers Next)
           (fact-name mother-com))))

(defrule question-mother-poster ""
  (mother-in-law-gift Poster)
  =>
  (assert (UI-state (display questionMotherPoster)
           (valid-answers Next)
           (fact-name mother-com))))

(defrule question-mother-in-law ""
 (mother-com Next)
 =>
  (assert
          (UI-state
          (valid-answers ForgetWhatSheWants KeepThinking)
          (fact-name mother-in-law-choice))))

(defrule question-sister ""
  (person Sister)
  =>
  (assert
           (UI-state (valid-answers Older Younger)
           (fact-name sister-age))))

(defrule question-sister-younger ""
  (sister-age Younger)
  =>
  (assert (UI-state (display questionSisterYounger)
                    (valid-answers  AdorableSister SpoiledSister)
                    (fact-name sister-spoiled))))

(defrule question-spoiled-yes ""
  (sister-spoiled SpoiledSister)
  =>
  (assert (UI-state (display questionSpoiledSister)
                    (valid-answers FreshStart)
                    (fact-name sister-forgive))))

(defrule question-co-worker-female ""
  (gender Female)
  (person Co-worker)
  =>
  (assert (UI-state (display questionCoWorkerFemale)
                    (valid-answers Cat DrewName)
                    (fact-name cat-or-santa))))

(defrule response-dad-tie-75 ""
  (ties-number MoreThan75)
  =>
  (assert (UI-state (display responseTie75)
            (state final))))

(defrule response-dad-tie-30 ""
  (ties-number LessThan75)
  =>
  (assert (UI-state (display responseTie30)
            (state final))))

(defrule response-dad-tools-yes ""
  (response-tools Yes)
  =>
  (assert (UI-state (display responseToolsYes)
            (state final))))

(defrule response-dad-tools-no ""
  (response-tools NoTools)
  =>
  (assert (UI-state (display responseToolsNo)
            (state final))))

(defrule response-dad-mug-yes ""
  (response-mug YesMug)
  =>
  (assert (UI-state (display responseMugYes)
            (state final))))

(defrule response-dad-mug-no ""
  (response-mug NoMug)
  =>
  (assert (UI-state (display responseMugNo)
            (state final))))

(defrule response-dad-grill ""
  (or (response-grill YesGrill) (response-grill NoGrill))
  =>
  (assert (UI-state (display responseGrill)
            (state final))))

(defrule response-brother-younger-yeah ""
  (response-you-picked YesYoungerBrother)
  =>
  (assert (UI-state (display responseBrotherYoungerYes)
            (state final))))

(defrule response-brother-younger-no ""
  (response-you-picked NoBrother)
  =>
  (assert (UI-state (display responseBrotherYoungerNo)
            (state final))))

(defrule response-brother-older-master ""
  (response-he-picked YesOlderBrother)
  =>
  (assert (UI-state (display responseBrotherOlderMaster)
            (state final))))

(defrule response-brother-older-no ""
  (response-he-picked NoBrother)
  =>
  (assert (UI-state (display responseBrotherOlderNo)
            (state final))))

(defrule response-uncle ""
  (or (uncle-when LastChristmasUncle)
    (uncle-when UncleThanksGiving)
    (uncle-when UncleLastWeek))
  =>
  (assert (UI-state (display responseUncle)
            (state final))))

(defrule response-worker-no ""
  (boss No)
  =>
  (assert (UI-state (display responseWorkerNo)
            (state final))))

(defrule response-worker-yes-no ""
  (like-boss No)
  =>
  (assert (UI-state (display responseWorkerYesNo)
            (state final))))

(defrule response-worker-yes-yes ""
  (like-boss Yes)
  =>
  (assert (UI-state (display responseWorkerYesYes)
            (state final))))

(defrule response-father-in-law ""
  (person Father-in-law)
  =>
  (assert (UI-state (display responseFatherInLaw)
            (state final))))

(defrule response-wife-yes ""
  (wife-brewers Yes)
  =>
  (assert (UI-state (display responseWifeYes)
            (state final))))

(defrule response-wife-no-clothes ""
  (wife-clothes No)
  =>
  (assert (UI-state (display responseNoClothes)
            (state final))))

(defrule response-wife-yes-clothes-36 ""
  (wife-size Size32)
  =>
  (assert (UI-state (display response36)
            (state final))))

(defrule response-wife-yes-clothes-not ""
  (wife-size NotChance)
  =>
  (assert (UI-state (display responseWifeYesClothesNot)
            (state final))))

(defrule response-girlfriend-yes ""
  (girlfriend-brewers Yes)
  =>
  (assert (UI-state (display responseGirlfriendYes)
            (state final))))

(defrule response-girlfriend-no ""
  (girlfriend-brewers NotYet)
  =>
  (assert (UI-state (display responseGirlfriendNo)
            (state final))))

(defrule response-mom-yes ""
  (mom-brewers Yes)
  =>
  (assert (UI-state (display responseMomYes)
            (state final))))

(defrule response-mom-gift ""
  (or (mom-gift FunOut) (mom-gift QualityTime) (mom-gift FoodAndDrink))
  =>
  (assert (UI-state (display responseMomGift)
            (state final))))

(defrule response-mother-gift-free ""
  (mom-gift HolidayOrnaments)
  =>
  (assert (UI-state (display responseMotherFree)
            (state final))))

(defrule response-mother-in-law-left ""
  (mother-in-law-choice ForgetWhatSheWants)
  =>
  (assert (UI-state (display responseMotherLeft)
          (state final))))

(defrule response-sister-older ""
  (sister-age Older)
  =>
  (assert (UI-state (display responseSisterOlder)
            (state final))))

(defrule response-sister-younger ""
  (or (sister-spoiled AdorableSister) (sister-forgive FreshStart))
  =>
  (assert (UI-state (display responseSisterYounger)
            (state final))))

(defrule response-co-worker-cat ""
  (cat-or-santa Cat)
  =>
  (assert (UI-state (display responseCoWorkerCat)
            (state final))))

 (defrule response-co-worker-santa ""
  (cat-or-santa DrewName)
  =>
  (assert (UI-state (display responseCoWorkerSanta)
            (state final))))