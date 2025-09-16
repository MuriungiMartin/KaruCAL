#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51489 "Detailed Enrollment"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Detailed Enrollment.rdlc';

    dataset
    {
        dataitem(UnknownTable61511;UnknownTable61511)
        {
            DataItemTableView = sorting(Code);
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Code","Stage Filter","Semester Filter","Student Type Filter";
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
            column(CurrReport_PAGENO_Control1000000006;CurrReport.PageNo)
            {
            }
            column(TIME;Time)
            {
            }
            column(Programme_Code;Code)
            {
            }
            column(Programme_Description;Description)
            {
            }
            column(HS;HS)
            {
            }
            column(Semester_Nomnal_RollCaption;Semester_Nomnal_RollCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Student_No_Caption;Student_No_CaptionLbl)
            {
            }
            column(NameCaption;NameCaptionLbl)
            {
            }
            column(GenderCaption;GenderCaptionLbl)
            {
            }
            column(No_Caption;No_CaptionLbl)
            {
            }
            column(DistrictCaption;DistrictCaptionLbl)
            {
            }
            column(Student_s_SignatureCaption;Student_s_SignatureCaptionLbl)
            {
            }
            column(Officer_s_SignatureCaption;Officer_s_SignatureCaptionLbl)
            {
            }
            column(Customer_NationalityCaption;Customer.FieldCaption(Nationality))
            {
            }
            column(RemarksCaption;RemarksCaptionLbl)
            {
            }
            column(Passport_or_National_IDCaption;Passport_or_National_IDCaptionLbl)
            {
            }
            column(Hall_and_Room_No_Caption;Hall_and_Room_No_CaptionLbl)
            {
            }
            column(Total_StudentsCaption;Total_StudentsCaptionLbl)
            {
            }
            column(Programme_Stage_Filter;"Stage Filter")
            {
            }
            column(Programme_Semester_Filter;"Semester Filter")
            {
            }
            column(Programme_Student_Type_Filter;"Student Type Filter")
            {
            }
            dataitem(UnknownTable61516;UnknownTable61516)
            {
                DataItemLink = "Programme Code"=field(Code),Code=field("Stage Filter"),"Semester Filter"=field("Semester Filter"),"Student Type Filter"=field("Student Type Filter");
                PrintOnlyIfDetail = true;
                column(ReportForNavId_3691; 3691)
                {
                }
                column(Programme_Stages_Programme_Code;"Programme Code")
                {
                }
                column(Programme_Stages_Code;Code)
                {
                }
                column(Programme_Stages_Semester_Filter;"Semester Filter")
                {
                }
                column(Programme_Stages_Student_Type_Filter;"Student Type Filter")
                {
                }
                dataitem(UnknownTable61532;UnknownTable61532)
                {
                    DataItemLink = Programme=field("Programme Code"),Stage=field(Code),Semester=field("Semester Filter"),"Settlement Type"=field("Student Type Filter");
                    DataItemTableView = sorting("Student Type") where(Reversed=const(No));
                    PrintOnlyIfDetail = true;
                    RequestFilterFields = "Settlement Type","Student No.",Registered;
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
                    column(Course_Registration_Settlement_Type;"Settlement Type")
                    {
                    }
                    dataitem(Customer;Customer)
                    {
                        DataItemLink = "No."=field("Student No.");
                        DataItemTableView = where(Status=filter(Registration|Current));
                        RequestFilterFields = District;
                        column(ReportForNavId_6836; 6836)
                        {
                        }
                        column(Customer_Name;Name)
                        {
                        }
                        column(Customer__No__;"No.")
                        {
                        }
                        column(Customer_Gender;Gender)
                        {
                        }
                        column(SNo;SNo)
                        {
                        }
                        column(dist;dist)
                        {
                        }
                        column(Customer_Nationality;Nationality)
                        {
                        }
                        column(Customer__ID_No_;"ID No")
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            SNo:=SNo+1;
                            if distrec.Get(Customer.District) then
                            dist:=distrec.Description;
                        end;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        
                        /*
                        IF Cust.GET("Course Registration"."Student No.") THEN BEGIN
                        Cust.CALCFIELDS(Cust.Balance);
                        SName:=Cust.Name;
                        SGender:=Cust.Gender;
                        SNationality:=Cust.Citizenship;
                        SBal:=Cust.Balance;
                        //Sdistrict:=
                        END
                        ELSE BEGIN
                        SName:='';
                        SGender:=Cust.Gender::Male;
                        SNationality:='KENYAN';
                        SBal:=0;
                        
                        END;
                        */

                    end;

                    trigger OnPreDataItem()
                    begin
                        LastFieldNo := FieldNo("Student Type");

                        "ACA-Course Registration".SetFilter("ACA-Course Registration".Semester,"ACA-Programme Stages".GetFilter("ACA-Programme Stages"."Semester Filter"))
                        ;
                        "ACA-Course Registration".SetFilter("ACA-Course Registration"."Registration Date",
                        "ACA-Programme Stages".GetFilter("ACA-Programme Stages"."Date Filter"));
                        "ACA-Course Registration".SetFilter("ACA-Course Registration".Status,"ACA-Programme Stages".GetFilter("ACA-Programme Stages".Status));
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
                SNo:=0;
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
        SGender: Option Male,Female;
        SNationality: Text[50];
        SBal: Decimal;
        SNo: Integer;
        Sdistrict: Text[50];
        HS: Integer;
        distrec: Record UnknownRecord61365;
        dist: Text[30];
        Semester_Nomnal_RollCaptionLbl: label 'Semester Nomnal Roll';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Student_No_CaptionLbl: label 'Student No.';
        NameCaptionLbl: label 'Name';
        GenderCaptionLbl: label 'Gender';
        No_CaptionLbl: label 'No.';
        DistrictCaptionLbl: label 'District';
        Student_s_SignatureCaptionLbl: label 'Student''s Signature';
        Officer_s_SignatureCaptionLbl: label 'Officer''s Signature';
        RemarksCaptionLbl: label 'Remarks';
        Passport_or_National_IDCaptionLbl: label 'Passport or National ID';
        Hall_and_Room_No_CaptionLbl: label 'Hall and Room No.';
        Total_StudentsCaptionLbl: label 'Total Students';
}

