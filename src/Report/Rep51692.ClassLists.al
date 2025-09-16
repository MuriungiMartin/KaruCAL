#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51692 "Class Lists"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Class Lists.rdlc';

    dataset
    {
        dataitem(UnknownTable61511;UnknownTable61511)
        {
            DataItemTableView = sorting(Code);
            RequestFilterFields = "Code","Semester Filter","Date Filter";
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
            column(Programme_Code;Code)
            {
            }
            column(Programme_Description;Description)
            {
            }
            column(Programme__Semester_Filter_;"Semester Filter")
            {
            }
            column(Programme__School_Code_;"School Code")
            {
            }
            column(TODAY;Today)
            {
            }
            column(Stage;Stage)
            {
            }
            column(StudType;StudType)
            {
            }
            column(ProgrammeCaption;ProgrammeCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Programme_CodeCaption;FieldCaption(Code))
            {
            }
            column(Programme_DescriptionCaption;FieldCaption(Description))
            {
            }
            column(Programme__Semester_Filter_Caption;FieldCaption("Semester Filter"))
            {
            }
            column(Programme__School_Code_Caption;FieldCaption("School Code"))
            {
            }
            column(LectureCaption;LectureCaptionLbl)
            {
            }
            column(StageCaption;StageCaptionLbl)
            {
            }
            column(Issued_OnCaption;Issued_OnCaptionLbl)
            {
            }
            column(Student_TypeCaption;Student_TypeCaptionLbl)
            {
            }
            dataitem(UnknownTable61516;UnknownTable61516)
            {
                DataItemLink = "Programme Code"=field(Code);
                RequestFilterFields = "Programme Code";
                column(ReportForNavId_3691; 3691)
                {
                }
                column(TotalReg;TotalReg)
                {
                }
                column(Programme_Stages_Programme_Code;"Programme Code")
                {
                }
                column(Programme_Stages_Code;Code)
                {
                }
                dataitem(UnknownTable61532;UnknownTable61532)
                {
                    DataItemLink = Programme=field("Programme Code"),Stage=field(Code);
                    DataItemTableView = sorting("Student Type");
                    RequestFilterFields = "Student Type",Programme,Stage;
                    column(ReportForNavId_2901; 2901)
                    {
                    }
                    column(SName;SName)
                    {
                    }
                    column(Hesabu;Hesabu)
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

                    trigger OnAfterGetRecord()
                    begin
                        if Cust.Get("ACA-Course Registration"."Student No.") then
                        SName:=Cust.Name
                        else
                        SName:='';
                        Hesabu:=Hesabu+1;
                    end;

                    trigger OnPreDataItem()
                    begin
                        LastFieldNo := FieldNo("Student Type");

                        "ACA-Course Registration".SetFilter("ACA-Course Registration".Semester,"ACA-Programme Stages".GetFilter("ACA-Programme Stages"."Semester Filter"))
                        ;
                        "ACA-Course Registration".SetFilter("ACA-Course Registration"."Registration Date",
                        "ACA-Programme Stages".GetFilter("ACA-Programme Stages"."Date Filter"));
                        "ACA-Course Registration".SetFilter("ACA-Course Registration".Status,"ACA-Programme Stages".GetFilter("ACA-Programme Stages".Status));
                        Stage:="ACA-Course Registration".GetFilter("ACA-Course Registration".Stage);
                        StudType:="ACA-Course Registration".GetFilter("ACA-Course Registration"."Student Type");
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    TotalIncome:=TotalIncome+"ACA-Programme Stages"."Total Income";
                    TotalReg:=TotalReg+"ACA-Programme Stages"."Student Registered";
                end;

                trigger OnPreDataItem()
                begin
                    "ACA-Programme Stages".SetFilter("ACA-Programme Stages"."Semester Filter","ACA-Programme".GetFilter("ACA-Programme"."Semester Filter"));
                    "ACA-Programme Stages".SetFilter("ACA-Programme Stages"."Date Filter","ACA-Programme".GetFilter("ACA-Programme"."Date Filter"));
                    "ACA-Programme Stages".SetFilter("ACA-Programme Stages".Status,"ACA-Programme".GetFilter("ACA-Programme".Status));
                end;
            }

            trigger OnAfterGetRecord()
            begin
                TotalIncome:=0;
                TotalReg:=0;
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
        TotalIncome: Decimal;
        TotalReg: Integer;
        Cust: Record Customer;
        SName: Text[200];
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        Hesabu: Integer;
        Stage: Text[30];
        StudType: Text[30];
        ProgrammeCaptionLbl: label 'Programme';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        LectureCaptionLbl: label 'Lecture';
        StageCaptionLbl: label 'Stage';
        Issued_OnCaptionLbl: label 'Issued On';
        Student_TypeCaptionLbl: label 'Student Type';
}

