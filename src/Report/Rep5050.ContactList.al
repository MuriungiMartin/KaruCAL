#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5050 "Contact - List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Contact - List.rdlc';
    Caption = 'Contact - List';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(Contact;Contact)
        {
            RequestFilterFields = "No.","Search Name",Type,"Salesperson Code","Post Code","Country/Region Code";
            column(ReportForNavId_6698; 6698)
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(Contact_TABLECAPTION__________ContactFilter;TableCaption + ': ' + ContactFilter)
            {
            }
            column(ShowContactFilter;ContactFilter)
            {
            }
            column(Contact__No__;"No.")
            {
            }
            column(Contact__Cost__LCY__;"Cost (LCY)")
            {
            }
            column(Contact__Estimated_Value__LCY__;"Estimated Value (LCY)")
            {
            }
            column(Contact__Calcd__Current_Value__LCY__;"Calcd. Current Value (LCY)")
            {
            }
            column(Contact__No__of_Opportunities_;"No. of Opportunities")
            {
            }
            column(Contact__Duration__Min___;"Duration (Min.)")
            {
            }
            column(Contact__Next_To_do_Date_;Format("Next To-do Date"))
            {
            }
            column(Contact_Type;Type)
            {
            }
            column(GroupNo;GroupNo)
            {
            }
            column(ContAddr_1_;ContAddr[1])
            {
            }
            column(ContAddr_2_;ContAddr[2])
            {
            }
            column(ContAddr_3_;ContAddr[3])
            {
            }
            column(ContAddr_4_;ContAddr[4])
            {
            }
            column(ContAddr_5_;ContAddr[5])
            {
            }
            column(ContAddr_6_;ContAddr[6])
            {
            }
            column(ContAddr_7_;ContAddr[7])
            {
            }
            column(ContAddr_8_;ContAddr[8])
            {
            }
            column(Contact___ListCaption;Contact___ListCaptionLbl)
            {
            }
            column(PageCaption;PageCaptionLbl)
            {
            }
            column(Contact__No__Caption;FieldCaption("No."))
            {
            }
            column(Contact_TypeCaption;FieldCaption(Type))
            {
            }
            column(Contact__Cost__LCY__Caption;FieldCaption("Cost (LCY)"))
            {
            }
            column(Contact__No__of_Opportunities_Caption;FieldCaption("No. of Opportunities"))
            {
            }
            column(Contact__Estimated_Value__LCY__Caption;FieldCaption("Estimated Value (LCY)"))
            {
            }
            column(Contact__Calcd__Current_Value__LCY__Caption;FieldCaption("Calcd. Current Value (LCY)"))
            {
            }
            column(Contact__Duration__Min___Caption;FieldCaption("Duration (Min.)"))
            {
            }
            column(Contact__Next_To_do_Date_Caption;Contact__Next_To_do_Date_CaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                FormatAddr.ContactAddr(ContAddr,Contact);
                if Counter = RecPerPageNum then begin
                  GroupNo := GroupNo + 1;
                  Counter := 0;
                end;
                Counter := Counter + 1;
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

    trigger OnPreReport()
    begin
        ContactFilter := Contact.GetFilters;

        GroupNo := 1;
        RecPerPageNum := 4;
    end;

    var
        FormatAddr: Codeunit "Format Address";
        ContAddr: array [8] of Text[50];
        ContactFilter: Text;
        GroupNo: Integer;
        Counter: Integer;
        RecPerPageNum: Integer;
        Contact___ListCaptionLbl: label 'Contact - List';
        PageCaptionLbl: label 'Page';
        Contact__Next_To_do_Date_CaptionLbl: label 'Next To-do Date';
}

