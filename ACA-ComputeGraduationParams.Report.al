#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 78009 "ACA-Compute Graduation Params"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(UnknownTable61532;UnknownTable61532)
        {
            DataItemTableView = where(Status=filter(Current|Registration|Deceased),"Is Final Year Student"=filter(Yes));
            column(ReportForNavId_1; 1)
            {
            }

            trigger OnAfterGetRecord()
            var
                SuppExists: Boolean;
            begin
                //"ACA-Course Registration".VALIDATE("ACA-Course Registration"."General Remark");
                //"ACA-Course Registration".MODIFY;
                 progress.Update(1,"ACA-Course Registration"."Student No.");
                 progress.Update(2,"ACA-Course Registration".Programme);
                 progress.Update(3,"ACA-Course Registration".Semester);
                 progress.Update(4,"ACA-Course Registration".Stage);

                "ACA-Course Registration"."Yearly Graduating Average":=0;
                "ACA-Course Registration"."Final Graduating Average":=0;
                "ACA-Course Registration"."Yearly Grad. W. Average":=0;
                "ACA-Course Registration"."Final Grad. W.Average":=0;
                "ACA-Course Registration"."Final Clasification":='';


                "ACA-Course Registration"."Yearly Passed (To Graduate)":=false;

                "ACA-Course Registration".CalcFields(
                "ACA-Course Registration"."Yearly Passed Cores",
                "ACA-Course Registration"."Yearly Passed Electives",
                "ACA-Course Registration"."Final  Grad. Req. Units",
                "ACA-Course Registration"."Yearly Grad. Req. Units");
                Clear(PassedCores);
                Clear(PassedElectives);
                Clear(ReasonForNotGrad);
                Clear(ExpectedElectives);
                Clear(ToGraduate);
                if "ACA-Course Registration"."Yearly Grad. Req. Units"=0 then exit;
                ExpectedElectives:="ACA-Course Registration"."Yearly Grad. Req. Units"-"ACA-Course Registration"."Yearly Passed Cores";
                PassedCores:="ACA-Course Registration"."Yearly Passed Cores";
                ///////////////////////////////////////////Initializa all Graduating Units for the YoS
                ACAStudentUnits.Reset;
                ACAStudentUnits.SetRange("Student No.","ACA-Course Registration"."Student No.");
                ACAStudentUnits.SetRange("Year Of Study","ACA-Course Registration"."Year Of Study");
                ACAStudentUnits.SetRange("Reg. Reversed",false);
                if ACAStudentUnits.Find('-') then begin
                repeat
                begin
                  ACAStudentUnits."Include in Graduation":=false;
                  ACAStudentUnits.Modify;
                end;
                until ((ACAStudentUnits.Next=0))
                end;

                //Update all Passed Cores
                ACAStudentUnits.Reset;
                ACAStudentUnits.SetRange("Student No.","ACA-Course Registration"."Student No.");
                ACAStudentUnits.SetRange("Year Of Study","ACA-Course Registration"."Year Of Study");
                ACAStudentUnits.SetRange("Reg. Reversed",false);
                ACAStudentUnits.SetRange("Unit Type (Flow)",ACAStudentUnits."unit type (flow)"::Core);
                ACAStudentUnits.SetFilter("Supp. Grade",'A|B|C|D');
                if ACAStudentUnits.Find('-') then begin
                //ACAStudentUnits.SETCURRENTKEY(ACAStudentUnits."Supp. Grade");
                repeat
                begin
                  //Check Total Electives Here
                  ACAStudentUnits."Include in Graduation":=true;
                  ACAStudentUnits.Modify;

                end;
                until ((ACAStudentUnits.Next=0))
                end;
                ////////////////////////////////
                if ExpectedElectives>0 then begin
                ACAStudentUnits.Reset;
                ACAStudentUnits.SetRange("Student No.","ACA-Course Registration"."Student No.");
                ACAStudentUnits.SetRange("Year Of Study","ACA-Course Registration"."Year Of Study");
                ACAStudentUnits.SetRange("Reg. Reversed",false);
                ACAStudentUnits.SetRange("Unit Type (Flow)",ACAStudentUnits."unit type (flow)"::Elective);
                ACAStudentUnits.SetFilter("Supp. Grade",'A|B|C|D');
                if ACAStudentUnits.Find('-') then begin
                ACAStudentUnits.SetCurrentkey(ACAStudentUnits."Supp. Grade");
                repeat
                begin
                  //Check Total Electives Here
                    ACAStudentUnits."Include in Graduation":=true;
                  ACAStudentUnits.Modify;

                  PassedElectives:=PassedElectives+ACAStudentUnits.Units;
                end;
                until ((ACAStudentUnits.Next=0) or (PassedElectives=ExpectedElectives))
                end;

                end;// Load Electives only if Cores are less than expected

                if not ((PassedElectives+PassedCores)<"ACA-Course Registration"."Yearly Grad. Req. Units") then begin
                  // The Course Registration Meets the Graduation Criteria
                  ToGraduate:=true;
                  end;

                "ACA-Course Registration"."Yearly Passed (To Graduate)":=ToGraduate;

                "ACA-Course Registration".CalcFields(
                "ACA-Course Registration"."Yearly Graduating Units Count",
                "ACA-Course Registration"."Yearly Graduating Core Units",
                "ACA-Course Registration"."Yearly Graduating Electives",
                "ACA-Course Registration"."Yearly Grad. Req. Units",
                "ACA-Course Registration"."Final  Graduating Units Count",
                "ACA-Course Registration"."Final  Graduating Core Units",
                "ACA-Course Registration"."Final  Graduating Electives",
                "ACA-Course Registration"."Final  Grad. Req. Units",
                "ACA-Course Registration"."Is Final Year Student",
                "ACA-Course Registration"."Yearly Graduating Marks",
                "ACA-Course Registration"."Final Graduating Marks",
                "ACA-Course Registration"."Yearly Graduating Courses",
                "ACA-Course Registration"."Final Graduating Courses",
                "ACA-Course Registration"."Yearly Grad. Weighted Units",
                "ACA-Course Registration"."Final Grad. Weighted Units",
                "ACA-Course Registration"."Final Graduation YoS",
                "ACA-Course Registration"."Yearly Passed Cores",
                "ACA-Course Registration"."Yearly Passed Electives",
                "ACA-Course Registration"."No. of Registrations",
                "ACA-Course Registration"."Exists Where Not Graduating");

                if "ACA-Course Registration"."Yearly Graduating Courses">0 then
                "ACA-Course Registration"."Yearly Graduating Average":=("ACA-Course Registration"."Yearly Graduating Marks"/"ACA-Course Registration"."Yearly Graduating Courses");
                if "ACA-Course Registration"."Final Graduating Courses">0 then
                "ACA-Course Registration"."Final Graduating Average":=("ACA-Course Registration"."Final Graduating Marks"/"ACA-Course Registration"."Final Graduating Courses");
                if "ACA-Course Registration"."Yearly Graduating Units Count">0 then
                "ACA-Course Registration"."Yearly Grad. W. Average":=("ACA-Course Registration"."Yearly Grad. Weighted Units"/"ACA-Course Registration"."Yearly Graduating Units Count");
                if "ACA-Course Registration"."Final  Graduating Units Count">0 then
                "ACA-Course Registration"."Final Grad. W.Average":=("ACA-Course Registration"."Final Grad. Weighted Units"/"ACA-Course Registration"."Final  Graduating Units Count");
                if "ACA-Course Registration"."Final Graduating Average">0 then
                "ACA-Course Registration"."Final Clasification":=GetClassification("ACA-Course Registration".Programme,"ACA-Course Registration"."Final Graduating Average");
                 if ToGraduate=false then begin
                   "ACA-Course Registration"."Reason not to Graduate":='INCOMPLETE';
                end;
                "ACA-Course Registration".CalcFields("ACA-Course Registration"."Program Option (Flow)");
                "ACA-Course Registration".Modify;

                ClassificationMarksheetCntrl.Reset;
                ClassificationMarksheetCntrl.SetRange("Grad. Academic Year","ACA-Course Registration"."Graduation Academic Year");
                ClassificationMarksheetCntrl.SetRange("Programme Option","ACA-Course Registration"."Program Option (Flow)");
                ClassificationMarksheetCntrl.SetRange("Programme Code","ACA-Course Registration".Programme);
                ClassificationMarksheetCntrl.SetRange("Academic Year","ACA-Course Registration"."Academic Year");
                ClassificationMarksheetCntrl.SetRange("Year of Study","ACA-Course Registration"."Year Of Study");
                if not ClassificationMarksheetCntrl.Find('-') then begin
                    //Insert
                ClassificationMarksheetCntrl.Init;
                ClassificationMarksheetCntrl."Grad. Academic Year":="ACA-Course Registration"."Graduation Academic Year";
                ClassificationMarksheetCntrl."Programme Code":="ACA-Course Registration".Programme;
                ClassificationMarksheetCntrl."Programme Option":="ACA-Course Registration"."Program Option (Flow)";
                ClassificationMarksheetCntrl."Academic Year":="ACA-Course Registration"."Academic Year";
                ClassificationMarksheetCntrl."Year of Study":="ACA-Course Registration"."Year Of Study";
                if "ACA-Course Registration"."Year Of Study"<>0 then
                ClassificationMarksheetCntrl.Insert;
                  end;

                ACACourseRegistration33.Reset;
                ACACourseRegistration33.SetRange("Student No.","ACA-Course Registration"."Student No.");
                ACACourseRegistration33.SetRange("Final Passed (To Graduate)",false);
                if ACACourseRegistration33.Find('-') then begin
                  ACACourseRegistration334.Reset;
                  ACACourseRegistration334.SetRange("Student No.","ACA-Course Registration"."Student No.");
                  if ACACourseRegistration334.Find('-') then begin
                    repeat
                        begin
                         // ACACourseRegistration334."Reason not to Graduate":='INCOMPLETE';
                          ACACourseRegistration334."Final Clasification":='INCOMPLETE';
                          ACACourseRegistration334.Modify;

                        end;
                      until ACACourseRegistration334.Next=0;
                      end;
                  end;
            end;

            trigger OnPreDataItem()
            begin
                // // // //"ACA-Exam Results".SETRANGE("ACA-Exam Results"."User Name",UserID);
                // // //
                // // // //Reset Exam Status
                // // // ACACourseRegistration.RESET;
                // // // ACACourseRegistration.COPYFILTERS("ACA-Course Registration");
                // // // //IF ("ACA-Course Registration".GETFILTER("ACA-Course Registration"."Academic Year"))<>'' THEN
                // // // //  ACACourseRegistration.SETRANGE("Academic Year",("ACA-Course Registration".GETFILTER("ACA-Course Registration"."Academic Year")));
                // // // IF ACACourseRegistration.FIND('-') THEN
                // // //  REPEAT
                // // //    ACACourseRegistration."Supp. Yearly Remarks":='';
                // // //    ACACourseRegistration.MODIFY;
                // // //    UNTIL ACACourseRegistration.NEXT=0;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
         progress.Close;
    end;

    trigger OnPreReport()
    begin
         progress.Open('Computing Graduation Parameters......\Stud. No: #1###############################################'+
         '\Programme: #2###############################################\Semester: #3###############################################'+
         '\Stage: #4###############################################');
    end;

    var
        ACAStudentUnits: Record UnknownRecord61549;
        ACAStudentUnits2: Record UnknownRecord61549;
        ACACourseRegistration: Record UnknownRecord61532;
        ACAProgramme: Record UnknownRecord61511;
        ACAUnitsSubjects: Record UnknownRecord61517;
        ACAGradingSystemSetup: Record UnknownRecord61599;
        ACADefinedUnitsperYoS: Record UnknownRecord78017;
        PassedCores: Decimal;
        PassedElectives: Decimal;
        ExpectedElectives: Decimal;
        ReasonForNotGrad: Text[100];
        ToGraduate: Boolean;
        progress: Dialog;
        ACAProgramme2: Record UnknownRecord61511;
        ACACourseRegistration33: Record UnknownRecord61532;
        ACACourseRegistration334: Record UnknownRecord61532;
        ClassificationMarksheetCntrl: Record UnknownRecord78007;

    local procedure GetClassification(ProgramCode: Code[20];AverageScore: Decimal) Classification: Code[20]
    begin
        Clear(Classification);
        ACAProgramme2.Reset;
        ACAProgramme2.SetRange(Code,ProgramCode);
        if ACAProgramme2.Find('-') then begin
        ACAGradingSystemSetup.Reset;
          ACAGradingSystemSetup.SetRange(Category,ACAProgramme2."Exam Category");
          ACAGradingSystemSetup.SetFilter("Lower Limit",'=%1|<%2',AverageScore,AverageScore);
          ACAGradingSystemSetup.SetFilter("Upper Limit",'>%2|=%1',AverageScore,AverageScore);
          if ACAGradingSystemSetup.Find('-') then begin
              Classification:=ACAGradingSystemSetup.Remarks;
            end;
          end;
    end;
}

