#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51372 "Units signoff1"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Units signoff1.rdlc';

    dataset
    {
        dataitem(UnknownTable61511;UnknownTable61511)
        {
            RequestFilterFields = "Code";
            column(ReportForNavId_1410; 1410)
            {
            }
            column(Programme_Description;Description)
            {
            }
            column(TODAY;Today)
            {
            }
            column(Programme_Faculty;Faculty)
            {
            }
            column(UPPERCASE_USERID_;UpperCase(UserId))
            {
            }
            column(coursereg_Stage;coursereg.Stage)
            {
            }
            column(COURSE_REGISTRATIONCaption;COURSE_REGISTRATIONCaptionLbl)
            {
            }
            column(SIGNATURECaption;SIGNATURECaptionLbl)
            {
            }
            column(COURSES_REGISTEREDCaption;COURSES_REGISTEREDCaptionLbl)
            {
            }
            column(STUDENT_NO___NAMECaption;STUDENT_NO___NAMECaptionLbl)
            {
            }
            column(Programme_Code;Code)
            {
            }
            dataitem(Customer;Customer)
            {
                DataItemLink = "Student Programme"=field(Code);
                DataItemTableView = where(Status=const(Current));
                RequestFilterFields = "No.";
                column(ReportForNavId_6836; 6836)
                {
                }
                column(Customer_No_;"No.")
                {
                }
                column(Customer_Student_Programme;"Student Programme")
                {
                }
                dataitem(UnknownTable61532;UnknownTable61532)
                {
                    DataItemLink = "Student No."=field("No.");
                    DataItemTableView = sorting("Student No.");
                    RequestFilterFields = Stage,Semester;
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
                    dataitem(UnknownTable61549;UnknownTable61549)
                    {
                        DataItemLink = "Student No."=field("Student No."),Stage=field(Stage);
                        column(ReportForNavId_2992; 2992)
                        {
                        }
                    }

                    trigger OnAfterGetRecord()
                    begin
                        /*
                        coursereg.SETRANGE(coursereg."Student No.",cust."No.");
                        IF coursereg.FIND('+') THEN BEGIN
                          regtid:=coursereg."Reg. Transacton ID";
                        END;
                        
                        studentunitrec.SETRANGE(studentunitrec."Student No.","Course Registration"."Student No.");
                        //studentunitrec.SETRANGE(studentunitrec."Reg. Transacton ID",regtid);
                        studentunitrec.SETRANGE(studentunitrec.Stage,coursereg.Stage);
                        
                         StudentU:='';
                        IF studentunitrec.FIND('-') THEN BEGIN
                          REPEAT
                            StudentU:=StudentU+'  '+studentunitrec.Unit;
                          UNTIL studentunitrec.NEXT=0;
                        END;
                        
                        cust.RESET;
                        cust.SETRANGE(cust."No.","Course Registration"."Student No.");
                        IF cust.FIND('-') THEN  BEGIN
                          Sname:=cust.Name;
                        END;
                        */

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
                    coursereg.SetRange(coursereg."Student No.",cust."No.");


                    studentunitrec.SetRange(studentunitrec."Student No.","No.");

                    studentunitrec.SetRange(studentunitrec.Stage,YXSX);

                     StudentU:='';
                    if studentunitrec.Find('-') then begin
                      repeat
                        StudentU:=StudentU+'  '+studentunitrec.Unit;
                      until studentunitrec.Next=0;
                    end;

                    cust.Reset;
                    cust.SetRange(cust."No.","No.");
                    if cust.Find('-') then  begin
                      Sname:=cust.Name;
                    end;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Dimrec.Reset;
                Dimrec.SetRange(Dimrec.Code,"ACA-Programme".Faculty);
                if Dimrec.Find('-') then begin
                  Faculty:=Dimrec.Name;
                end;
            end;

            trigger OnPreDataItem()
            begin
                if YXSX='' then
                Error('Please enter the Year');
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
        Faculty: Text[150];
        Dimrec: Record "Dimension Value";
        sem: Text[150];
        YXSX: Text[30];
        COURSE_REGISTRATIONCaptionLbl: label 'COURSE REGISTRATION';
        SIGNATURECaptionLbl: label 'SIGNATURE';
        COURSES_REGISTEREDCaptionLbl: label 'COURSES REGISTERED';
        STUDENT_NO___NAMECaptionLbl: label 'STUDENT NO & NAME';
}

