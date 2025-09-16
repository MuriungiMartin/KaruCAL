#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51421 "Student Units Registration"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Student Units Registration.rdlc';

    dataset
    {
        dataitem(UnknownTable61511;UnknownTable61511)
        {
            DataItemTableView = sorting(Code);
            RequestFilterFields = Faculty,"Code","Semester Filter";
            column(ReportForNavId_1410; 1410)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(USERID;UserId)
            {
            }
            column(UnitNotReg;UnitNotReg)
            {
            }
            column(UnitReg;UnitReg)
            {
            }
            column(SemNotReg;SemNotReg)
            {
            }
            column(SemReg;SemReg)
            {
            }
            column(Programme_Description;Description)
            {
            }
            column(Programme_Code;Code)
            {
            }
            column(STUDENTS_COURSE_REGISTRATION_STATUSCaption;STUDENTS_COURSE_REGISTRATION_STATUSCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(CodeCaption;CodeCaptionLbl)
            {
            }
            column(DescriptionCaption;DescriptionCaptionLbl)
            {
            }
            column(Semester_RegesteredCaption;Semester_RegesteredCaptionLbl)
            {
            }
            column(Semester_Not_Reg_Caption;Semester_Not_Reg_CaptionLbl)
            {
            }
            column(Course_RegisteredCaption;Course_RegisteredCaptionLbl)
            {
            }
            column(Course_Not_Reg_Caption;Course_Not_Reg_CaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                  SemReg:=0;
                  UnitReg:=0;
                  UnitNotReg:=0;
                  SemNotReg:=0;


                   // Check Semester Registration
                  SemRegistered:=false;
                  Customer.CalcFields(Customer."Student Programme");
                  Customer.SetRange(Customer."Student Programme","ACA-Programme".Code);
                  if Customer.Find('-') then begin
                  repeat
                  CReg.Reset;
                  CReg.SetRange(CReg."Student No.",Customer."No.");
                  CReg.SetRange(CReg.Programme,"ACA-Programme".Code);
                  CReg.SetFilter(CReg.Semester,"ACA-Programme".GetFilter("ACA-Programme"."Semester Filter"));
                  if CReg.Find('-') then begin
                    SemRegistered:=true;
                    SemReg:=SemReg+1 ;
                  end else begin
                    SemRegistered:=false;
                    SemNotReg:=SemNotReg+1;
                  end;

                  // Check Course Registraion
                  if SemRegistered then begin
                  SUnits.Reset;
                  SUnits.SetRange(SUnits."Student No.",Customer."No.");
                  SUnits.SetRange(SUnits.Programme,"ACA-Programme".Code);
                  SUnits.SetRange(SUnits.Semester,"ACA-Programme".GetFilter("Semester Filter"));
                  if SUnits.Count>=7 then
                    UnitReg:=UnitReg+1
                  else
                    UnitNotReg:=UnitNotReg+1;
                 end;
                 until Customer.Next=0;
                 end;
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
        SemReg: Integer;
        UnitReg: Integer;
        UnitNotReg: Integer;
        SemNotReg: Integer;
        CReg: Record UnknownRecord61532;
        SUnits: Record UnknownRecord61549;
        SemRegistered: Boolean;
        Customer: Record Customer;
        STUDENTS_COURSE_REGISTRATION_STATUSCaptionLbl: label 'STUDENTS COURSE REGISTRATION STATUS';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        CodeCaptionLbl: label 'Code';
        DescriptionCaptionLbl: label 'Description';
        Semester_RegesteredCaptionLbl: label 'Semester Regestered';
        Semester_Not_Reg_CaptionLbl: label 'Semester Not Reg.';
        Course_RegisteredCaptionLbl: label 'Course Registered';
        Course_Not_Reg_CaptionLbl: label 'Course Not Reg.';
}

