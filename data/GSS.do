#delimit ;

   infix
      year     1 - 20
      id_      21 - 40
      health   41 - 60
      class_   61 - 80
      helpsick 81 - 100
using GSS.dat;

label variable year     "Gss year for this respondent                       ";
label variable id_      "Respondent id number";
label variable health   "Condition of health";
label variable class_   "Subjective class identification";
label variable helpsick "Should govt help pay for medical care?";


label define gsp001x
   9        "No answer"
   8        "Don't know"
   4        "Poor"
   3        "Fair"
   2        "Good"
   1        "Excellent"
   0        "Not applicable"
;
label define gsp002x
   9        "No answer"
   8        "Don't know"
   5        "No class"
   4        "Upper class"
   3        "Middle class"
   2        "Working class"
   1        "Lower class"
   0        "Not applicable"
;
label define gsp003x
   9        "No answer"
   8        "Don't know"
   5        "People help selves"
   3        "Agree with both"
   1        "Govt should help"
   0        "Not applicable"
;


label values health   gsp001x;
label values class_   gsp002x;
label values helpsick gsp003x;


