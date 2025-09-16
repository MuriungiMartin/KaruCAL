#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51315 "Meals Requistion"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Meals Requistion.rdlc';

    dataset
    {
        dataitem(UnknownTable61778;UnknownTable61778)
        {
            column(ReportForNavId_8573; 8573)
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
            column(Office_Transactions_No;"CAT-Meal Booking Header"."Booking Id")
            {
            }
            column(Office_Transactions_Date;"CAT-Meal Booking Header"."Request Date")
            {
            }
            column(Office_Transactions_Description;"CAT-Meal Booking Header"."Meeting Name")
            {
            }
            column(Office_Transactions_Amount;"CAT-Meal Booking Header"."Total Cost")
            {
            }
            column(Office_Transactions__From_G_L_No_;"CAT-Meal Booking Header".Department)
            {
            }
            column(Office_Transactions__To_G_L_No_;"CAT-Meal Booking Header"."Department Name")
            {
            }
            column(Office_Transactions_Department;"CAT-Meal Booking Header"."Contact Person")
            {
            }
            column(Office_Transactions_Amount_Control1102760000;"CAT-Meal Booking Header"."Total Cost")
            {
            }
            column(Meals_RequisitionCaption;Meals_RequisitionCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Office_Transactions_NoCaption;FieldCaption("Booking Id"))
            {
            }
            column(Office_Transactions_DateCaption;FieldCaption("Request Date"))
            {
            }
            column(Office_Transactions_DescriptionCaption;FieldCaption("Meeting Name"))
            {
            }
            column(Office_Transactions_AmountCaption;FieldCaption("Total Cost"))
            {
            }
            column(Office_Transactions__From_G_L_No_Caption;FieldCaption(Department))
            {
            }
            column(Office_Transactions__To_G_L_No_Caption;FieldCaption("Department Name"))
            {
            }
            column(Office_Transactions_DepartmentCaption;FieldCaption("Contact Person"))
            {
            }
            column(TotalCaption;TotalCaptionLbl)
            {
            }

            trigger OnPreDataItem()
            begin
                //LastFieldNo := FIELDNO(No);
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
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        TotalFor: label 'Total for ';
        Meals_RequisitionCaptionLbl: label 'Meals Requisition';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        TotalCaptionLbl: label 'Total';
}

