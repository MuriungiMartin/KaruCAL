#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51371 "Units signoff"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Units signoff.rdlc';

    dataset
    {
        dataitem(UnknownTable61511;UnknownTable61511)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Code";
            column(ReportForNavId_1410; 1410)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(USERID;UserId)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(Programme_Description;Description)
            {
            }
            column(Programme_Code;Code)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Course_RegistrationCaption;Course_RegistrationCaptionLbl)
            {
            }
            column(Course_Registration__Student_No__Caption;"ACA-Course Registration".FieldCaption("Student No."))
            {
            }
            column(SignatureCaption;SignatureCaptionLbl)
            {
            }
            column(Units_RegisteredCaption;Units_RegisteredCaptionLbl)
            {
            }
            dataitem(UnknownTable61532;UnknownTable61532)
            {
                DataItemLink = Programme=field(Code);
                DataItemTableView = sorting("Student No.");
                PrintOnlyIfDetail = true;
                RequestFilterFields = "Student No.",Stage,Programme,Semester;
                column(ReportForNavId_2901; 2901)
                {
                }
                column(Course_Registration__Student_No__;"Student No.")
                {
                }
                column(StudentU;StudentU)
                {
                }
                column(Sname;Sname)
                {
                }
                column(HS;HS)
                {
                }
                column(Course_Registration_Reg__Transacton_ID;"Reg. Transacton ID")
                {
                }
                column(Course_Registration_Programme;Programme)
                {
                }
                column(Course_Registration_Semester;Semester)
                {
                }
                column(Course_Registration_Register_for;"Register for")
                {
                }
                column(Course_Registration_Stage;Stage)
                {
                }
                column(Course_Registration_Unit;Unit)
                {
                }
                column(Course_Registration_Student_Type;"Student Type")
                {
                }
                column(Course_Registration_Entry_No_;"Entry No.")
                {
                }
                dataitem(Customer;Customer)
                {
                    DataItemLink = "No."=field("Student No.");
                    RequestFilterFields = "No.",Status,"Balance (LCY)";
                    column(ReportForNavId_6836; 6836)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                           HS:=HS+1;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    coursereg.SetRange(coursereg."Student No.",cust."No.");
                    if coursereg.Find('+') then begin
                      regtid:=coursereg."Reg. Transacton ID";
                    end;

                    studentunitrec.SetRange(studentunitrec."Student No.","ACA-Course Registration"."Student No.");
                    //studentunitrec.SETRANGE(studentunitrec."Reg. Transacton ID",regtid);
                    studentunitrec.SetRange(studentunitrec.Stage,coursereg.Stage);

                     StudentU:='';
                    if studentunitrec.Find('-') then begin
                      repeat
                        StudentU:=StudentU+'  '+studentunitrec.Unit;
                      until studentunitrec.Next=0;
                    end;

                    cust.Reset;
                    cust.SetRange(cust."No.","ACA-Course Registration"."Student No.");
                    if cust.Find('-') then  begin
                      Sname:=cust.Name;
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    coursereg.SetRange(coursereg."Student No.",cust."No.");
                    if coursereg.Find('+') then begin
                      regtid:=coursereg."Reg. Transacton ID";
                    end;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                  HS:=0;
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
        StudentU: Text[300];
        studentunitrec: Record UnknownRecord61549;
        cust: Record Customer;
        Sname: Text[150];
        coursereg: Record UnknownRecord61532;
        regtid: Code[20];
        Yearfilter: Text[30];
        HS: Integer;
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Course_RegistrationCaptionLbl: label 'Course Registration';
        SignatureCaptionLbl: label 'Signature';
        Units_RegisteredCaptionLbl: label 'Units Registered';
}

