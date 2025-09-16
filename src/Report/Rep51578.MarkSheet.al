#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51578 "Mark Sheet"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Mark Sheet.rdlc';

    dataset
    {
        dataitem(UnknownTable61511;UnknownTable61511)
        {
            DataItemTableView = sorting(Code);
            RequestFilterFields = "Code","Stage Filter","Semester Filter";
            column(ReportForNavId_1410; 1410)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(USERID;UserId)
            {
            }
            column(FDesc;FDesc)
            {
            }
            column(Programme_Description;Description)
            {
            }
            column(Dept;Dept)
            {
            }
            column(Individual_Mark_SheetCaption;Individual_Mark_SheetCaptionLbl)
            {
            }
            column(Faculty_Caption;Faculty_CaptionLbl)
            {
            }
            column(Programme_of_Study_Caption;Programme_of_Study_CaptionLbl)
            {
            }
            column(Department_Caption;Department_CaptionLbl)
            {
            }
            column(Exam_Date_Caption;Exam_Date_CaptionLbl)
            {
            }
            column(Programme_Code;Code)
            {
            }
            column(Programme_Stage_Filter;"Stage Filter")
            {
            }
            dataitem(UnknownTable61516;UnknownTable61516)
            {
                DataItemLink = "Programme Code"=field(Code),Code=field("Stage Filter");
                column(ReportForNavId_3691; 3691)
                {
                }
                column(Programme_Stages_Description;Description)
                {
                }
                column(Year_Caption;Year_CaptionLbl)
                {
                }
                column(Programme_Stages_Programme_Code;"Programme Code")
                {
                }
                column(Programme_Stages_Code;Code)
                {
                }
                dataitem(UnknownTable61517;UnknownTable61517)
                {
                    DataItemLink = "Programme Code"=field("Programme Code"),"Stage Code"=field(Code);
                    RequestFilterFields = "Code";
                    column(ReportForNavId_2955; 2955)
                    {
                    }
                    column(Units_Subjects_Desription;Desription)
                    {
                    }
                    column(Units_Subjects__No__Units_;"No. Units")
                    {
                    }
                    column(Units_Subjects_Code;Code)
                    {
                    }
                    column(CurrReport_PAGENO;CurrReport.PageNo)
                    {
                    }
                    column(RemarksCaption;RemarksCaptionLbl)
                    {
                    }
                    column(GradeCaption;GradeCaptionLbl)
                    {
                    }
                    column(EmptyStringCaption;EmptyStringCaptionLbl)
                    {
                    }
                    column(EmptyStringCaption_Control1102760083;EmptyStringCaption_Control1102760083Lbl)
                    {
                    }
                    column(Agreed_Total_MarksCaption;Agreed_Total_MarksCaptionLbl)
                    {
                    }
                    column(EmptyStringCaption_Control1102760084;EmptyStringCaption_Control1102760084Lbl)
                    {
                    }
                    column(EmptyStringCaption_Control1102760087;EmptyStringCaption_Control1102760087Lbl)
                    {
                    }
                    column(Total_marksCaption;Total_marksCaptionLbl)
                    {
                    }
                    column(EmptyStringCaption_Control1102760080;EmptyStringCaption_Control1102760080Lbl)
                    {
                    }
                    column(EmptyStringCaption_Control1102760081;EmptyStringCaption_Control1102760081Lbl)
                    {
                    }
                    column(EmptyStringCaption_Control1102760082;EmptyStringCaption_Control1102760082Lbl)
                    {
                    }
                    column(EmptyStringCaption_Control1102760085;EmptyStringCaption_Control1102760085Lbl)
                    {
                    }
                    column(EmptyStringCaption_Control1102760088;EmptyStringCaption_Control1102760088Lbl)
                    {
                    }
                    column(Exam_Marks_70_Caption;Exam_Marks_70_CaptionLbl)
                    {
                    }
                    column(EmptyStringCaption_Control1102760077;EmptyStringCaption_Control1102760077Lbl)
                    {
                    }
                    column(EmptyStringCaption_Control1102760078;EmptyStringCaption_Control1102760078Lbl)
                    {
                    }
                    column(EmptyStringCaption_Control1102760079;EmptyStringCaption_Control1102760079Lbl)
                    {
                    }
                    column(C_W_30_Caption;C_W_30_CaptionLbl)
                    {
                    }
                    column(EmptyStringCaption_Control1102760074;EmptyStringCaption_Control1102760074Lbl)
                    {
                    }
                    column(EmptyStringCaption_Control1102760075;EmptyStringCaption_Control1102760075Lbl)
                    {
                    }
                    column(EmptyStringCaption_Control1102760076;EmptyStringCaption_Control1102760076Lbl)
                    {
                    }
                    column(EmptyStringCaption_Control1102760071;EmptyStringCaption_Control1102760071Lbl)
                    {
                    }
                    column(EmptyStringCaption_Control1102760072;EmptyStringCaption_Control1102760072Lbl)
                    {
                    }
                    column(EmptyStringCaption_Control1102760073;EmptyStringCaption_Control1102760073Lbl)
                    {
                    }
                    column(Title_of_Paper_Caption;Title_of_Paper_CaptionLbl)
                    {
                    }
                    column(Name_of_CandidateCaption;Name_of_CandidateCaptionLbl)
                    {
                    }
                    column(No__of_Units_Caption;No__of_Units_CaptionLbl)
                    {
                    }
                    column(Registration_NumberCaption;Registration_NumberCaptionLbl)
                    {
                    }
                    column(Serial_NumberCaption;Serial_NumberCaptionLbl)
                    {
                    }
                    column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
                    {
                    }
                    column(Units_Subjects_Programme_Code;"Programme Code")
                    {
                    }
                    column(Units_Subjects_Stage_Code;"Stage Code")
                    {
                    }
                    column(Units_Subjects_Entry_No;"Entry No")
                    {
                    }
                    dataitem(UnknownTable61549;UnknownTable61549)
                    {
                        DataItemLink = Programme=field("Programme Code"),Stage=field("Stage Code"),Unit=field(Code);
                        column(ReportForNavId_2992; 2992)
                        {
                        }
                        column(Student_Units__Student_No__;"Student No.")
                        {
                        }
                        column(RCount;RCount)
                        {
                        }
                        column(Names;Names)
                        {
                        }
                        column(ICaption;ICaptionLbl)
                        {
                        }
                        column(ECaption;ECaptionLbl)
                        {
                        }
                        column(EmptyStringCaption_Control1102760049;EmptyStringCaption_Control1102760049Lbl)
                        {
                        }
                        column(EmptyStringCaption_Control1102760050;EmptyStringCaption_Control1102760050Lbl)
                        {
                        }
                        column(EmptyStringCaption_Control1102760052;EmptyStringCaption_Control1102760052Lbl)
                        {
                        }
                        column(EmptyStringCaption_Control1102760053;EmptyStringCaption_Control1102760053Lbl)
                        {
                        }
                        column(EmptyStringCaption_Control1102760054;EmptyStringCaption_Control1102760054Lbl)
                        {
                        }
                        column(EmptyStringCaption_Control1102760048;EmptyStringCaption_Control1102760048Lbl)
                        {
                        }
                        column(EmptyStringCaption_Control1102760051;EmptyStringCaption_Control1102760051Lbl)
                        {
                        }
                        column(EmptyStringCaption_Control1102760055;EmptyStringCaption_Control1102760055Lbl)
                        {
                        }
                        column(EmptyStringCaption_Control1102760056;EmptyStringCaption_Control1102760056Lbl)
                        {
                        }
                        column(EmptyStringCaption_Control1102760057;EmptyStringCaption_Control1102760057Lbl)
                        {
                        }
                        column(EmptyStringCaption_Control1102760058;EmptyStringCaption_Control1102760058Lbl)
                        {
                        }
                        column(EmptyStringCaption_Control1102760059;EmptyStringCaption_Control1102760059Lbl)
                        {
                        }
                        column(EmptyStringCaption_Control1102760060;EmptyStringCaption_Control1102760060Lbl)
                        {
                        }
                        column(EmptyStringCaption_Control1102760061;EmptyStringCaption_Control1102760061Lbl)
                        {
                        }
                        column(EmptyStringCaption_Control1102760062;EmptyStringCaption_Control1102760062Lbl)
                        {
                        }
                        column(EmptyStringCaption_Control1102760063;EmptyStringCaption_Control1102760063Lbl)
                        {
                        }
                        column(EmptyStringCaption_Control1102760064;EmptyStringCaption_Control1102760064Lbl)
                        {
                        }
                        column(EmptyStringCaption_Control1102760065;EmptyStringCaption_Control1102760065Lbl)
                        {
                        }
                        column(EmptyStringCaption_Control1102760066;EmptyStringCaption_Control1102760066Lbl)
                        {
                        }
                        column(EmptyStringCaption_Control1102760067;EmptyStringCaption_Control1102760067Lbl)
                        {
                        }
                        column(EmptyStringCaption_Control1102760068;EmptyStringCaption_Control1102760068Lbl)
                        {
                        }
                        column(EmptyStringCaption_Control1102760069;EmptyStringCaption_Control1102760069Lbl)
                        {
                        }
                        column(EmptyStringCaption_Control1102760070;EmptyStringCaption_Control1102760070Lbl)
                        {
                        }
                        column(Signed_by__________________________________________________________________________________________Caption;Signed_by__________________________________________________________________________________________CaptionLbl)
                        {
                        }
                        column(Internal_ExaminerCaption;Internal_ExaminerCaptionLbl)
                        {
                        }
                        column(DataItem1102760027;Signed_by__________________________________________________________________________________________Caption_Control1102760027Lbl)
                        {
                        }
                        column(Head_of_DepartmentCaption;Head_of_DepartmentCaptionLbl)
                        {
                        }
                        column(DateCaption;DateCaptionLbl)
                        {
                        }
                        column(DateCaption_Control1102760032;DateCaption_Control1102760032Lbl)
                        {
                        }
                        column(DataItem1102760033;Signed_by__________________________________________________________________________________________Caption_Control1102760033Lbl)
                        {
                        }
                        column(DataItem1102760034;Signed_by__________________________________________________________________________________________Caption_Control1102760034Lbl)
                        {
                        }
                        column(External_ExaminerCaption;External_ExaminerCaptionLbl)
                        {
                        }
                        column(Dean_DirectorCaption;Dean_DirectorCaptionLbl)
                        {
                        }
                        column(DateCaption_Control1102760037;DateCaption_Control1102760037Lbl)
                        {
                        }
                        column(DateCaption_Control1102760038;DateCaption_Control1102760038Lbl)
                        {
                        }
                        column(Student_Units_Programme;Programme)
                        {
                        }
                        column(Student_Units_Stage;Stage)
                        {
                        }
                        column(Student_Units_Unit;Unit)
                        {
                        }
                        column(Student_Units_Semester;Semester)
                        {
                        }
                        column(Student_Units_Reg__Transacton_ID;"Reg. Transacton ID")
                        {
                        }
                        column(Student_Units_ENo;ENo)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            RCount:=RCount+1;
                            Names:='';

                            if Cust.Get("ACA-Student Units"."Student No.") then
                            Names:=Cust.Name;
                        end;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        RCount:=0;
                    end;
                }
            }

            trigger OnAfterGetRecord()
            begin

                FDesc:='';
                Dept:='';

                if FacultyR.Get("ACA-Programme".Faculty) then
                FDesc:=FacultyR.Description;

                DValue.Reset;
                DValue.SetRange(DValue.Code,"ACA-Programme"."School Code");
                if DValue.Find('-') then
                Dept:=DValue.Name;
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
        RCount: Integer;
        Cust: Record Customer;
        Names: Text[200];
        DValue: Record "Dimension Value";
        FacultyR: Record UnknownRecord61587;
        FDesc: Text[200];
        Dept: Text[200];
        Individual_Mark_SheetCaptionLbl: label 'Individual Mark Sheet';
        Faculty_CaptionLbl: label 'Faculty:';
        Programme_of_Study_CaptionLbl: label 'Programme of Study:';
        Department_CaptionLbl: label 'Department:';
        Exam_Date_CaptionLbl: label 'Exam Date:';
        Year_CaptionLbl: label 'Year:';
        RemarksCaptionLbl: label 'Remarks';
        GradeCaptionLbl: label 'Grade';
        EmptyStringCaptionLbl: label '|';
        EmptyStringCaption_Control1102760083Lbl: label '|';
        Agreed_Total_MarksCaptionLbl: label 'Agreed Total Marks';
        EmptyStringCaption_Control1102760084Lbl: label '|';
        EmptyStringCaption_Control1102760087Lbl: label '|';
        Total_marksCaptionLbl: label 'Total marks';
        EmptyStringCaption_Control1102760080Lbl: label '|';
        EmptyStringCaption_Control1102760081Lbl: label '|';
        EmptyStringCaption_Control1102760082Lbl: label '|';
        EmptyStringCaption_Control1102760085Lbl: label '|';
        EmptyStringCaption_Control1102760088Lbl: label '|';
        Exam_Marks_70_CaptionLbl: label 'Exam Marks 70%';
        EmptyStringCaption_Control1102760077Lbl: label '|';
        EmptyStringCaption_Control1102760078Lbl: label '|';
        EmptyStringCaption_Control1102760079Lbl: label '|';
        C_W_30_CaptionLbl: label 'C/W 30%';
        EmptyStringCaption_Control1102760074Lbl: label '|';
        EmptyStringCaption_Control1102760075Lbl: label '|';
        EmptyStringCaption_Control1102760076Lbl: label '|';
        EmptyStringCaption_Control1102760071Lbl: label '|';
        EmptyStringCaption_Control1102760072Lbl: label '|';
        EmptyStringCaption_Control1102760073Lbl: label '|';
        Title_of_Paper_CaptionLbl: label 'Title of Paper:';
        Name_of_CandidateCaptionLbl: label 'Name of Candidate';
        No__of_Units_CaptionLbl: label 'No. of Units:';
        Registration_NumberCaptionLbl: label 'Registration Number';
        Serial_NumberCaptionLbl: label 'Serial Number';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        ICaptionLbl: label 'I';
        ECaptionLbl: label 'E';
        EmptyStringCaption_Control1102760049Lbl: label '-----------------------------------------------------------------------------------------------------------------------------------------------------------';
        EmptyStringCaption_Control1102760050Lbl: label '--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------';
        EmptyStringCaption_Control1102760052Lbl: label '|';
        EmptyStringCaption_Control1102760053Lbl: label '|';
        EmptyStringCaption_Control1102760054Lbl: label '|';
        EmptyStringCaption_Control1102760048Lbl: label '|';
        EmptyStringCaption_Control1102760051Lbl: label '|';
        EmptyStringCaption_Control1102760055Lbl: label '|';
        EmptyStringCaption_Control1102760056Lbl: label '|';
        EmptyStringCaption_Control1102760057Lbl: label '|';
        EmptyStringCaption_Control1102760058Lbl: label '|';
        EmptyStringCaption_Control1102760059Lbl: label '|';
        EmptyStringCaption_Control1102760060Lbl: label '|';
        EmptyStringCaption_Control1102760061Lbl: label '|';
        EmptyStringCaption_Control1102760062Lbl: label '|';
        EmptyStringCaption_Control1102760063Lbl: label '|';
        EmptyStringCaption_Control1102760064Lbl: label '|';
        EmptyStringCaption_Control1102760065Lbl: label '|';
        EmptyStringCaption_Control1102760066Lbl: label '|';
        EmptyStringCaption_Control1102760067Lbl: label '|';
        EmptyStringCaption_Control1102760068Lbl: label '|';
        EmptyStringCaption_Control1102760069Lbl: label '|';
        EmptyStringCaption_Control1102760070Lbl: label '|';
        Signed_by__________________________________________________________________________________________CaptionLbl: label 'Signed by:   ......................................................................................';
        Internal_ExaminerCaptionLbl: label 'Internal Examiner';
        Signed_by__________________________________________________________________________________________Caption_Control1102760027Lbl: label 'Signed by:   ......................................................................................';
        Head_of_DepartmentCaptionLbl: label 'Head of Department';
        DateCaptionLbl: label '/Date';
        DateCaption_Control1102760032Lbl: label '/Date';
        Signed_by__________________________________________________________________________________________Caption_Control1102760033Lbl: label 'Signed by:   ......................................................................................';
        Signed_by__________________________________________________________________________________________Caption_Control1102760034Lbl: label 'Signed by:   ......................................................................................';
        External_ExaminerCaptionLbl: label 'External Examiner';
        Dean_DirectorCaptionLbl: label 'Dean/Director';
        DateCaption_Control1102760037Lbl: label '/Date';
        DateCaption_Control1102760038Lbl: label '/Date';
}

