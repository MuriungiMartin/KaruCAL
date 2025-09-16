#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51374 "Sign Off 2"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Sign Off 2.rdlc';

    dataset
    {
        dataitem(UnknownTable61511;UnknownTable61511)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Code","Stage Filter","Semester Filter";
            column(ReportForNavId_1410; 1410)
            {
            }
            column(Programme_Description;Description)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(USERID;UserId)
            {
            }
            column(Programme_Description_Control1102760005;Description)
            {
            }
            column(Programme_Code;Code)
            {
            }
            column(Course_Check_ListCaption;Course_Check_ListCaptionLbl)
            {
            }
            column(KARATINA_UNIVERSITYCaption;KARATINA_UNIVERSITYCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(SignatureCaption;SignatureCaptionLbl)
            {
            }
            column(Units_RegisteredCaption;Units_RegisteredCaptionLbl)
            {
            }
            column(Student_NoCaption;Student_NoCaptionLbl)
            {
            }
            column(Programme_Stage_Filter;"Stage Filter")
            {
            }
            dataitem(UnknownTable61532;UnknownTable61532)
            {
                DataItemLink = Programme=field(Code),Stage=field("Stage Filter");
                DataItemTableView = sorting(Stage) order(ascending);
                PrintOnlyIfDetail = true;
                column(ReportForNavId_2901; 2901)
                {
                }
                column(Course_Registration_Reg__Transacton_ID;"Reg. Transacton ID")
                {
                }
                column(Course_Registration_Student_No_;"Student No.")
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
                dataitem(Student;Customer)
                {
                    DataItemLink = "No."=field("Student No.");
                    PrintOnlyIfDetail = false;
                    RequestFilterFields = "No.",Status,"Balance (LCY)";
                    column(ReportForNavId_3468; 3468)
                    {
                    }
                    column(StudentU;StudentU)
                    {
                    }
                    column(Sname;Sname)
                    {
                    }
                    column(No;No)
                    {
                    }
                    column(Student__No__;"No.")
                    {
                    }

                    trigger OnPreDataItem()
                    begin
                        //Student.SETFILTER(Student.Status,Programme.GETFILTER(Programme."Status Filter"));
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
            }
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
        No: Integer;
        "Total Count": Integer;
        StudentU: Text[300];
        studentunitrec: Record UnknownRecord61549;
        cust: Record Customer;
        Sname: Text[150];
        coursereg: Record UnknownRecord61532;
        regtid: Code[20];
        Yearfilter: Text[30];
        HS: Integer;
        Course_Check_ListCaptionLbl: label 'Course Check List';
        KARATINA_UNIVERSITYCaptionLbl: label 'KARATINA UNIVERSITY';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        SignatureCaptionLbl: label 'Signature';
        Units_RegisteredCaptionLbl: label 'Units Registered';
        Student_NoCaptionLbl: label 'Student No';
}

