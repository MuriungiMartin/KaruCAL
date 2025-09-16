#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 70084 "Validate Applications"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(UnknownTable61358;UnknownTable61358)
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if "ACA-Applic. Form Header"."Admitted Degree"<>'' then begin
                  ACAProgramme.Reset;
                  ACAProgramme.SetRange(Code,"ACA-Applic. Form Header"."Admitted Degree");
                  if ACAProgramme.Find('-') then begin
                    if ACAProgramme."Campus Code"<> '' then begin
                   "ACA-Applic. Form Header".Campus:=ACAProgramme."Campus Code";
                    "ACA-Applic. Form Header".Modify;
                        Customer.Reset;
                  Customer.SetRange("No.","ACA-Applic. Form Header"."Admission No");
                  //Customer.SETFILTER("Date Registered",'=%1',TODAY);
                  if Customer.Find('-') then begin
                    Customer."Global Dimension 1 Code":=ACAProgramme."Campus Code";
                    Customer.Modify;
                        end;
                      end;
                  end;
                  end;
                
                /*
                  Customer.RESET;
                  Customer.SETRANGE("No.","ACA-Applic. Form Header"."Admission No");
                  //Customer.SETFILTER("Date Registered",'=%1',TODAY);
                  IF Customer.FIND('-') THEN BEGIN
                "ACA-Applic. Form Header"."Documents Verified":=TRUE;
                "ACA-Applic. Form Header"."Documents Verification Remarks":='OK';
                
                "ACA-Applic. Form Header".MODIFY;
                
                    IF "ACA-Applic. Form Header".Gender="ACA-Applic. Form Header".Gender::Female THEN BEGIN
                      Customer.Gender:=Customer.Gender::Female;
                      END ELSE BEGIN
                         Customer.Gender:=Customer.Gender::Male;
                        END;
                        Customer.MODIFY;
                        END;
                
                 IF "ACA-Applic. Form Header"."Admitted Degree"<>'P109' THEN BEGIN
                  Customer.RESET;
                  Customer.SETRANGE("No.","ACA-Applic. Form Header"."Admission No");
                  Customer.SETFILTER("Date Registered",'=%1',TODAY);
                  IF Customer.FIND('-') THEN BEGIN
                  CourseRegistration.RESET;
                  CourseRegistration.SETRANGE("Student No.","ACA-Applic. Form Header"."Admission No");
                  CourseRegistration.SETRANGE("Settlement Type","ACA-Applic. Form Header"."Settlement Type");
                  CourseRegistration.SETRANGE(Programme,"ACA-Applic. Form Header"."First Degree Choice");
                  CourseRegistration.SETRANGE(Semester,"ACA-Applic. Form Header"."Admitted Semester");
                  IF NOT CourseRegistration.FIND('-') THEN BEGIN
                            CourseRegistration.INIT;
                               CourseRegistration."Reg. Transacton ID":='';
                               CourseRegistration.VALIDATE(CourseRegistration."Reg. Transacton ID");
                               CourseRegistration."Student No.":="ACA-Applic. Form Header"."Admission No";
                               CourseRegistration.Programme:="ACA-Applic. Form Header"."Admitted Degree";
                               CourseRegistration.Gender:=Customer.Gender;
                               CourseRegistration.Semester:="ACA-Applic. Form Header"."Admitted Semester";
                               CourseRegistration.Stage:="ACA-Applic. Form Header"."Admitted To Stage";
                               CourseRegistration."Student Type":=CourseRegistration."Student Type"::"Full Time";
                               CourseRegistration."Registration Date":=TODAY;
                               CourseRegistration."Settlement Type":="ACA-Applic. Form Header"."Settlement Type";
                               CourseRegistration."Academic Year":=GetCurrYear();
                               //CourseRegistration.VALIDATE(CourseRegistration."Settlement Type");
                            CourseRegistration.INSERT;
                  CourseRegistration.RESET;
                  CourseRegistration.SETRANGE("Student No.","ACA-Applic. Form Header"."Admission No");
                  CourseRegistration.SETRANGE("Settlement Type","ACA-Applic. Form Header"."Settlement Type");
                  CourseRegistration.SETRANGE(Programme,"ACA-Applic. Form Header"."First Degree Choice");
                  CourseRegistration.SETRANGE(Semester,"ACA-Applic. Form Header"."Admitted Semester");
                  IF  CourseRegistration.FIND('-') THEN BEGIN
                            CourseRegistration."Settlement Type":="ACA-Applic. Form Header"."Settlement Type";
                            CourseRegistration.VALIDATE(CourseRegistration."Settlement Type");
                            CourseRegistration."Academic Year":=GetCurrYear();
                               CourseRegistration.Gender:=Customer.Gender;
                            CourseRegistration."Registration Date":=TODAY;
                            CourseRegistration.VALIDATE(CourseRegistration."Registration Date");
                            CourseRegistration.MODIFY;
                
                            END;
                            END ELSE BEGIN
                                CourseRegistration.RESET;
                  CourseRegistration.SETRANGE("Student No.","ACA-Applic. Form Header"."Admission No");
                  CourseRegistration.SETRANGE("Settlement Type","ACA-Applic. Form Header"."Settlement Type");
                  CourseRegistration.SETRANGE(Programme,"ACA-Applic. Form Header"."First Degree Choice");
                  CourseRegistration.SETRANGE(Semester,"ACA-Applic. Form Header"."Admitted Semester");
                  CourseRegistration.SETFILTER(Posted,'=%1',FALSE);
                  IF  CourseRegistration.FIND('-') THEN BEGIN
                            CourseRegistration."Settlement Type":="ACA-Applic. Form Header"."Settlement Type";
                            CourseRegistration.VALIDATE(CourseRegistration."Settlement Type");
                            CourseRegistration."Academic Year":=GetCurrYear();
                               CourseRegistration.Gender:=Customer.Gender;
                            CourseRegistration."Registration Date":=TODAY;
                            CourseRegistration.VALIDATE(CourseRegistration."Registration Date");
                            CourseRegistration.MODIFY;
                
                            END;
                              END;
                            END;
                            END;
                            */

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

    var
        CourseRegistration: Record UnknownRecord61532;
        Customer: Record Customer;
        ACAProgramme: Record UnknownRecord61511;
}

