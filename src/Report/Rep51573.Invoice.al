#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51573 Invoice
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Invoice.rdlc';

    dataset
    {
        dataitem(UnknownTable61532;UnknownTable61532)
        {
            DataItemTableView = sorting("Student No.");
            RequestFilterFields = "Reg. Transacton ID","Student No.",Programme,Semester,"Register for",Stage,Unit,"Student Type";
            column(ReportForNavId_2901; 2901)
            {
            }
            column(Course_Registration__Student_No__;"Student No.")
            {
            }
            column(Course_Registration__Registration_Date_;"Registration Date")
            {
            }
            column(Course_Registration__Student_Type_;"Student Type")
            {
            }
            column(Stages_Description;Stages.Description)
            {
            }
            column(Prog_Description;Prog.Description)
            {
            }
            column(Cust_Name;Cust.Name)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(USERID;UserId)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(Course_Registration__Student_No__Caption;FieldCaption("Student No."))
            {
            }
            column(Course_Registration__Registration_Date_Caption;FieldCaption("Registration Date"))
            {
            }
            column(Course_Registration__Student_Type_Caption;FieldCaption("Student Type"))
            {
            }
            column(KARATINA_UNIVERSITYCaption;KARATINA_UNIVERSITYCaptionLbl)
            {
            }
            column(LevelCaption;LevelCaptionLbl)
            {
            }
            column(ProgrammeCaption;ProgrammeCaptionLbl)
            {
            }
            column(Cust__Ledger_Entry__Posting_Date_Caption;"Cust. Ledger Entry".FieldCaption("Posting Date"))
            {
            }
            column(Cust__Ledger_Entry__Document_No__Caption;"Cust. Ledger Entry".FieldCaption("Document No."))
            {
            }
            column(Cust__Ledger_Entry_DescriptionCaption;"Cust. Ledger Entry".FieldCaption(Description))
            {
            }
            column(Cust__Ledger_Entry__Currency_Code_Caption;"Cust. Ledger Entry".FieldCaption("Currency Code"))
            {
            }
            column(Cust__Ledger_Entry__Remaining_Amount_Caption;"Cust. Ledger Entry".FieldCaption("Remaining Amount"))
            {
            }
            column(INVOICECaption;INVOICECaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
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
            column(Course_Registration_Entry_No_;"Entry No.")
            {
            }
            dataitem("Cust. Ledger Entry";"Cust. Ledger Entry")
            {
                DataItemLink = "Customer No."=field("Student No.");
                DataItemTableView = where("Remaining Amount"=filter(>0),"Document No."=filter(<>'HELB JAN'));
                column(ReportForNavId_8503; 8503)
                {
                }
                column(Cust__Ledger_Entry__Posting_Date_;"Posting Date")
                {
                }
                column(Cust__Ledger_Entry__Document_No__;"Document No.")
                {
                }
                column(Cust__Ledger_Entry_Description;Description)
                {
                }
                column(Cust__Ledger_Entry__Currency_Code_;"Currency Code")
                {
                }
                column(Cust__Ledger_Entry__Remaining_Amount_;"Remaining Amount")
                {
                }
                column(Cust__Ledger_Entry__Remaining_Amount__Control1102760000;"Remaining Amount")
                {
                }
                column(TotalCaption;TotalCaptionLbl)
                {
                }
                column(Cust__Ledger_Entry_Entry_No_;"Entry No.")
                {
                }
                column(Cust__Ledger_Entry_Customer_No_;"Customer No.")
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                if Cust.Get("ACA-Course Registration"."Student No.") then
                RFound:=true;
                if Prog.Get("ACA-Course Registration".Programme) then
                RFound:=true;
                if Stages.Get("ACA-Course Registration".Programme,"ACA-Course Registration".Stage) then
                RFound:=true;
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
        Cust: Record Customer;
        Prog: Record UnknownRecord61511;
        Stages: Record UnknownRecord61516;
        RFound: Boolean;
        UDesc: Text[200];
        Units: Record UnknownRecord61517;
        KARATINA_UNIVERSITYCaptionLbl: label 'KARATINA UNIVERSITY';
        LevelCaptionLbl: label 'Level';
        ProgrammeCaptionLbl: label 'Programme';
        INVOICECaptionLbl: label 'INVOICE';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        TotalCaptionLbl: label 'Total';
}

