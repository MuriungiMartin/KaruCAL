#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51083 "Commitment Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Commitment Report.rdlc';

    dataset
    {
        dataitem("G/L Budget Name";"G/L Budget Name")
        {
            DataItemTableView = sorting(Name) order(ascending);
            RequestFilterHeading = 'Budget';
            column(ReportForNavId_4871; 4871)
            {
            }
            column(G_L_Budget_Name_Name;Name)
            {
            }
            dataitem("G/L Budget Entry";"G/L Budget Entry")
            {
                DataItemLink = "Budget Name"=field(Name);
                DataItemTableView = sorting("Budget Dimension 1 Code");
                RequestFilterFields = "Budget Dimension 1 Code";
                RequestFilterHeading = 'Department';
                column(ReportForNavId_3459; 3459)
                {
                }
                column(DeptName_Name;DeptName.Name)
                {
                }
                column(DeptName_Code;DeptName.Code)
                {
                }
                column(G_L_Budget_Entry_Date;Date)
                {
                }
                column(G_L_Budget_Entry__G_L_Account_No__;"G/L Account No.")
                {
                }
                column(G_L_Budget_Entry_Amount;Amount)
                {
                }
                column(G_L_Budget_Entry__User_ID_;"User ID")
                {
                }
                column(GlName_Name;GlName.Name)
                {
                }
                column(G_L_Budget_Entry_Amount_Control1102760024;Amount)
                {
                }
                column(G_L_Budget_Entry_DateCaption;FieldCaption(Date))
                {
                }
                column(AccountCaption;AccountCaptionLbl)
                {
                }
                column(AllocationCaption;AllocationCaptionLbl)
                {
                }
                column(G_L_Budget_Entry__User_ID_Caption;FieldCaption("User ID"))
                {
                }
                column(Account_NameCaption;Account_NameCaptionLbl)
                {
                }
                column(CommittmentCaption;CommittmentCaptionLbl)
                {
                }
                column(TotalCaption;TotalCaptionLbl)
                {
                }
                column(G_L_Budget_Entry_Entry_No_;"Entry No.")
                {
                }
                column(G_L_Budget_Entry_Budget_Dimension_1_Code;"Budget Dimension 1 Code")
                {
                }
                column(G_L_Budget_Entry_Budget_Name;"Budget Name")
                {
                }
                dataitem(UnknownTable61135;UnknownTable61135)
                {
                    DataItemLink = Account=field("G/L Account No."),Department=field("Budget Dimension 1 Code");
                    DataItemTableView = sorting(Department) order(ascending) where("Commitment Type"=const(Committed));
                    RequestFilterFields = Account;
                    RequestFilterHeading = 'G/L Account';
                    column(ReportForNavId_2097; 2097)
                    {
                    }
                    column(Commitment_Entries_Date;Date)
                    {
                    }
                    column(Commitment_Entries_Account;Account)
                    {
                    }
                    column(Commitment_Entries__Committed_Amount_;"Committed Amount")
                    {
                    }
                    column(Commitment_Entries_User;User)
                    {
                    }
                    column(Commitment_Entries__Commitment_No_;"Commitment No")
                    {
                    }
                    column(GlName_Name_Control1102760015;GlName.Name)
                    {
                    }
                    column(Balance;Balance)
                    {
                    }
                    column(Expense;Expense)
                    {
                    }
                    column(Commitment_Entries__Committed_Amount__Control1102760011;"Committed Amount")
                    {
                    }
                    column(G_L_Budget_Entry__Amount;"G/L Budget Entry".Amount)
                    {
                    }
                    column(Total_CommittedCaption;Total_CommittedCaptionLbl)
                    {
                    }
                    column(Commitment_Entries_Entry_No;"Entry No")
                    {
                    }
                    column(Commitment_Entries_Department;Department)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        GlName.Get("FIN-Commitment Entries".Account);
                        Balance:=Balance-"FIN-Commitment Entries"."Committed Amount";
                        gl.SetRange(gl."Document No.","FIN-Commitment Entries"."Commitment No");
                        if gl.Find('-') then begin
                          Expense:=gl."Debit Amount";
                        end;
                    end;

                    trigger OnPreDataItem()
                    begin
                        Balance:=Allocation;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    DeptName.Get("G/L Budget Entry"."Budget Dimension 1 Code");
                    GlName.Get("G/L Budget Entry"."G/L Account No.");
                    Allocation:="G/L Budget Entry".Amount;
                end;

                trigger OnPreDataItem()
                begin
                       GenSetUp.Get();
                       "G/L Budget Entry".SetFilter("G/L Budget Entry".Date,'%1..%2',GenSetUp."Current Budget Start Date",
                       GenSetUp."Current Budget End Date");
                end;
            }

            trigger OnPreDataItem()
            begin
                     GenSetUp.Get();
                     "G/L Budget Name".SetRange("G/L Budget Name".Name,GenSetUp."Current Budget");
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
        DeptName: Record "Dimension Value";
        GlName: Record "G/L Account";
        Balance: Decimal;
        Allocation: Decimal;
        gl: Record "G/L Entry";
        Expense: Decimal;
        GenSetUp: Record "General Ledger Setup";
        AccountCaptionLbl: label 'Account';
        AllocationCaptionLbl: label 'Allocation';
        Account_NameCaptionLbl: label 'Account Name';
        CommittmentCaptionLbl: label 'Committment';
        TotalCaptionLbl: label 'Total';
        Total_CommittedCaptionLbl: label 'Total Committed';
}

