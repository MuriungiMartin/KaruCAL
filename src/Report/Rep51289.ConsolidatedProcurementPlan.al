#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51289 "Consolidated Procurement Plan"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Consolidated Procurement Plan.rdlc';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(UnknownTable61696;UnknownTable61696)
        {
            RequestFilterFields = "Budget Name";
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
            column(Amount;"PROC-Procurement Plan Lines".Amount)
            {
            }
            column(Unit;"PROC-Procurement Plan Lines".Unit)
            {
            }
            column(Category;"PROC-Procurement Plan Lines".Category)
            {
            }
            column(unitcost;"PROC-Procurement Plan Lines"."Unit Cost")
            {
            }
            column(preference;"PROC-Procurement Plan Lines".Prefence)
            {
            }
            column(Reservation;"PROC-Procurement Plan Lines".Reservation)
            {
            }
            column(Q1;Q1)
            {
            }
            column(Q2;Q2)
            {
            }
            column(Q3;Q3)
            {
            }
            column(Q4;Q4)
            {
            }
            column(Category_ProcurementPlanLines;"PROC-Procurement Plan Lines".Category)
            {
            }
            column(A1;A1)
            {
            }
            column(A2;A2)
            {
            }
            column(A3;A3)
            {
            }
            column(A4;A4)
            {
            }
            column(Qty;TQ)
            {
            }
            column(EstCost;TU)
            {
            }
            column(TotaAmount;TA)
            {
            }
            column(BudgetAmount;Budgt)
            {
            }
            column(Methods;"PROC-Procurement Plan Lines".Method)
            {
            }
            column(Sourceoffunds;"PROC-Procurement Plan Lines"."Source of Funds")
            {
            }
            column(TimeProcess;"PROC-Procurement Plan Lines"."Time process")
            {
            }
            column(InviteAdvertiseTender;"PROC-Procurement Plan Lines"."Open Tender")
            {
            }
            column(EvaluateTender;"PROC-Procurement Plan Lines"."Evaluate tender")
            {
            }
            column(CommitteeSigning;"PROC-Procurement Plan Lines".Committee)
            {
            }
            column(ContractSigning;"PROC-Procurement Plan Lines"."Contract Signing")
            {
            }
            column(TotalTimetocontract;"PROC-Procurement Plan Lines"."Total time to contract")
            {
            }
            column(TotalTimeForcompletionofcontract;"PROC-Procurement Plan Lines"."Total time to completion")
            {
            }
            column(OpenTender;"PROC-Procurement Plan Lines"."Open Tender")
            {
            }
            column(Notification;"PROC-Procurement Plan Lines".notification)
            {
            }
            column(CompName;CompanyInformation.Name)
            {
            }
            column(CompAddress;CompanyInformation.Address)
            {
            }
            column(CompPhone;CompanyInformation."Phone No.")
            {
            }
            column(CompMail;CompanyInformation."E-Mail")
            {
            }
            column(CompUrl;CompanyInformation."Home Page")
            {
            }
            column(Logo;CompanyInformation.Picture)
            {
            }
            column(DepartmentName;DepartmentName)
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

                Q1:=0;
                Q2:=0;
                Q3:=0;
                Q4:=0;
                A1:=0;
                A2:=0;
                A3:=0;
                A4:=0;
                TQ:=0;
                TU:=0;
                TA:=0;

                  ProcPlanLine.Reset;
                  ProcPlanLine.SetRange(ProcPlanLine."Budget Name","PROC-Procurement Plan Lines"."Budget Name");
                  ProcPlanLine.SetRange(ProcPlanLine."Type No","PROC-Procurement Plan Lines"."Type No");
                  if ProcPlanLine.Find('-') then begin
                  repeat
                  TQ:=TQ+ProcPlanLine.Quantity;
                  TU:=ProcPlanLine."Unit Cost";
                  TA:=TA+ProcPlanLine.Amount;

                  if ProcPlanLine."Procurement Plan Period"='Q1' then begin
                  Q1:=Q1+ProcPlanLine.Quantity;
                  A1:=A1+ProcPlanLine.Amount;
                  end;
                  if ProcPlanLine."Procurement Plan Period"='Q2' then begin
                  Q2:=Q2+ProcPlanLine.Quantity;
                  A2:=A2+ProcPlanLine.Amount;
                  end;
                  if ProcPlanLine."Procurement Plan Period"='Q3' then begin
                  Q3:=Q3+ProcPlanLine.Quantity;
                  A3:=A3+ProcPlanLine.Amount;
                  end;
                  if ProcPlanLine."Procurement Plan Period"='Q4' then begin
                  Q4:=Q4+ProcPlanLine.Quantity;
                  A4:=A4+ProcPlanLine.Amount;
                  end;
                  until ProcPlanLine.Next=0;
                  end;

                if GL.Get("PROC-Procurement Plan Lines"."Type No") then begin
                GL.SetFilter(GL."Global Dimension 2 Filter","PROC-Procurement Plan Lines".Department);
                GL.CalcFields(GL."Budgeted Amount");
                Budgt:=GL."Budgeted Amount";
                end;
            end;

            trigger OnPreDataItem()
            begin
                CompanyInformation.Get;
                CompanyInformation.CalcFields(Picture);
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
        ProcPlanLine: Record UnknownRecord61696;
        Q1: Decimal;
        Q2: Decimal;
        Q3: Decimal;
        Q5: Decimal;
        Q6: Decimal;
        Q4: Decimal;
        A1: Decimal;
        A2: Decimal;
        A3: Decimal;
        A4: Decimal;
        TQ: Decimal;
        TU: Decimal;
        TA: Decimal;
        Budgt: Decimal;
        GL: Record "G/L Account";
        CompanyInformation: Record "Company Information";
        DepartmentName: Text[100];
}

