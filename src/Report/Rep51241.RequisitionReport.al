#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51241 "Requisition Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Requisition Report.rdlc';

    dataset
    {
        dataitem(UnknownTable61153;UnknownTable61153)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            column(ReportForNavId_1992; 1992)
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
            column(Internal_Requisition_Plan__Department_Name_;"Department Name")
            {
            }
            column(Internal_Requisition_Plan__Date_Required_;"Date Required")
            {
            }
            column(Internal_Requisition_Plan__Internal_Requisition_Plan___No__;"PROC-Internal Requisition Plan"."No.")
            {
            }
            column(Internal_Requisition_Plan__Plan_No_;"Plan No")
            {
            }
            column(Internal_Requisition_Plan__Date_Requisitioned_;"Date Requisitioned")
            {
            }
            column(THE_PURCHASE_REQUISITION_NOTECaption;THE_PURCHASE_REQUISITION_NOTECaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Department_Caption;Department_CaptionLbl)
            {
            }
            column(Internal_Requisition_Plan__Date_Required_Caption;FieldCaption("Date Required"))
            {
            }
            column(No_Caption;No_CaptionLbl)
            {
            }
            column(Internal_Requisition_Plan__Plan_No_Caption;FieldCaption("Plan No"))
            {
            }
            column(Internal_Requisition_Plan__Date_Requisitioned_Caption;FieldCaption("Date Requisitioned"))
            {
            }
            dataitem(UnknownTable61154;UnknownTable61154)
            {
                DataItemLink = "No."=field("No.");
                column(ReportForNavId_2561; 2561)
                {
                }
                column(Internal_Requisition_Plan_Line__Type_No__;"Type No.")
                {
                }
                column(Internal_Requisition_Plan_Line_Description;Description)
                {
                }
                column(Internal_Requisition_Plan_Line__Requested_Qty_;"Requested Qty")
                {
                }
                column(Internal_Requisition_Plan_Line__Unit_Direct_Cost_;"Unit Direct Cost")
                {
                }
                column(Internal_Requisition_Plan_Line__Total_Cost_;"Total Cost")
                {
                }
                column(Internal_Requisition_Plan_Line__Total_Cost__Control1102755006;"Total Cost")
                {
                }
                column(USERID_Control1000000031;UserId)
                {
                }
                column(Internal_Requisition_Plan___Date_Requisitioned_;"PROC-Internal Requisition Plan"."Date Requisitioned")
                {
                }
                column(Item_NoCaption;Item_NoCaptionLbl)
                {
                }
                column(Internal_Requisition_Plan_Line_DescriptionCaption;FieldCaption(Description))
                {
                }
                column(Internal_Requisition_Plan_Line__Requested_Qty_Caption;FieldCaption("Requested Qty"))
                {
                }
                column(Internal_Requisition_Plan_Line__Unit_Direct_Cost_Caption;FieldCaption("Unit Direct Cost"))
                {
                }
                column(Internal_Requisition_Plan_Line__Total_Cost_Caption;FieldCaption("Total Cost"))
                {
                }
                column(Total_CostCaption;Total_CostCaptionLbl)
                {
                }
                column(REQUISITIONED_BY_________________________________________Caption;REQUISITIONED_BY_________________________________________CaptionLbl)
                {
                }
                column(SIGNATURE___________________________Caption;SIGNATURE___________________________CaptionLbl)
                {
                }
                column(DATE________________________________Caption;DATE________________________________CaptionLbl)
                {
                }
                column(Internal_Requisition_Plan_Line_No_;"No.")
                {
                }
                column(Internal_Requisition_Plan_Line_Line_No_;"Line No.")
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                Dim.Reset;
                Dim.SetRange(Dim.Code,Department);
                if Dim.Find('-') then begin
                "Department Name":=Dim.Name;
                end;
            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("No.");
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
        Dim: Record "Dimension Value";
        THE_PURCHASE_REQUISITION_NOTECaptionLbl: label 'THE PURCHASE REQUISITION NOTE';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Department_CaptionLbl: label 'Department:';
        No_CaptionLbl: label 'No.';
        Item_NoCaptionLbl: label 'Item No';
        Total_CostCaptionLbl: label 'Total Cost';
        REQUISITIONED_BY_________________________________________CaptionLbl: label 'REQUISITIONED BY:________________________________________';
        SIGNATURE___________________________CaptionLbl: label 'SIGNATURE___________________________';
        DATE________________________________CaptionLbl: label 'DATE:_______________________________';
}

