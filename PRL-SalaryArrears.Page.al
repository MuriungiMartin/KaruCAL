#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68065 "PRL-Salary Arrears"
{
    PageType = List;
    SourceTable = UnknownTable61088;

    layout
    {
        area(content)
        {
            group("Basic Pay Arrears")
            {
                Caption = 'Basic Pay Arrears';
                field("Employee Code";"Employee Code")
                {
                    ApplicationArea = Basic;
                    Enabled = true;

                    trigger OnValidate()
                    begin
                        //Get the employee name
                        strEmpName:='';
                        objEmp.Reset;
                        objEmp.SetRange(objEmp."No.","Employee Code");
                        if objEmp.Find('-') then
                        strEmpName:=objEmp."First Name"+' '+objEmp."Middle Name"+' '+objEmp."Last Name";
                    end;
                }
                field(strEmpName;strEmpName)
                {
                    ApplicationArea = Basic;
                    Caption = 'Name';
                    Editable = false;
                    Enabled = true;
                }
                field("Transaction Code";"Transaction Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Period Month";"Period Month")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Period Year";"Period Year")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Start Date";"Start Date")
                {
                    ApplicationArea = Basic;
                }
                field("End Date";"End Date")
                {
                    ApplicationArea = Basic;
                }
                field("Current Basic";"Current Basic")
                {
                    ApplicationArea = Basic;
                }
                field("Salary Arrears";"Salary Arrears")
                {
                    ApplicationArea = Basic;
                    Style = Standard;
                    StyleExpr = true;
                }
                field("PAYE Arrears";"PAYE Arrears")
                {
                    ApplicationArea = Basic;
                    Style = Standard;
                    StyleExpr = true;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin

        strEmpCode:="Employee Code";
        strTransCode:="Transaction Code";
        //Get the employee name
        strEmpName:='';
        objEmp.Reset;
        objEmp.SetRange(objEmp."No.","Employee Code");
        if objEmp.Find('-') then
        strEmpName:=objEmp."First Name"+' '+objEmp."Middle Name"+' '+objEmp."Last Name";



        //Get the open/current period
        PayPeriod.SetRange(PayPeriod.Closed,false);
        if PayPeriod.Find('-') then
           PeriodMonth:=PayPeriod."Period Month";
           PeriodYear:=PayPeriod."Period Year";
           "Period Month":=PeriodMonth;
           "Period Year":=PeriodYear;

        //Get the Salary Arrears code
        TransCode.SetRange(TransCode."Special Transactions",6);
        if TransCode.Find('-') then
           strTransCode:=TransCode."Transaction Code";
           "Transaction Code":=strTransCode;

        //Get the staff current salary
        if SalCard.Get("Employee Code") then begin
           "Current Basic":=SalCard."Basic Pay";
        end;
    end;

    var
        objOcx: Codeunit "BankAcc.Recon. PostNew";
        SalCard: Record UnknownRecord61105;
        PayPeriod: Record UnknownRecord61081;
        PeriodMonth: Integer;
        PeriodYear: Integer;
        TransCode: Record UnknownRecord61082;
        strTransCode: Text[30];
        strEmpCode: Text[30];
        SalArr: Record UnknownRecord61088;
        strEmpName: Text[50];
        objEmp: Record UnknownRecord61118;
}

