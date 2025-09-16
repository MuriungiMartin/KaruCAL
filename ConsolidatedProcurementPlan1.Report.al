#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51285 "Consolidated Procurement Plan1"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Consolidated Procurement Plan1.rdlc';

    dataset
    {
        dataitem(UnknownTable61696;UnknownTable61696)
        {
            column(ReportForNavId_1102755008; 1102755008)
            {
            }
            column(BudgetName;"PROC-Procurement Plan Lines"."Budget Name")
            {
            }
            column(Dptmnt;"PROC-Procurement Plan Lines".Department)
            {
            }
            column(CampusCode;"PROC-Procurement Plan Lines".Campus)
            {
            }
            column(PlanPeriod;"PROC-Procurement Plan Lines"."Procurement Plan Period")
            {
            }
            column(No;"PROC-Procurement Plan Lines"."Type No")
            {
            }
            column(Description;"PROC-Procurement Plan Lines".Description)
            {
            }
            column(Quantity;"PROC-Procurement Plan Lines".Quantity)
            {
            }
            column(DeptName;DeptName)
            {
            }
            column(Total;TotalQuantity)
            {
            }

            trigger OnAfterGetRecord()
            begin
                DimVal.Reset;
                DimVal.SetRange(DimVal.Code,"PROC-Procurement Plan Lines".Department);
                if DimVal.Find('-') then begin
                DeptName:=DimVal.Name;
                end;
                CurrReport.CreateTotals("PROC-Procurement Plan Lines".Quantity);
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
        DimVal: Record "Dimension Value";
        ItemNo: Code[20];
        Description: Text[250];
        Quantity: Decimal;
        TotalQuantity: Decimal;
        PlanLines: Record UnknownRecord61696;
        DeptName: Text[250];
        Total: Decimal;
}

