#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68723 "PRL-Emp. Cue (Payroll)"
{
    PageType = CardPart;
    SourceTable = UnknownTable61682;

    layout
    {
        area(content)
        {
            cuegroup("All Employees")
            {
                Caption = 'All Employees';
                field("Employee-Active (PR)";"Employee-Active (PR)")
                {
                    ApplicationArea = Basic;
                    Caption = 'Active Employees';
                    DrillDownPageID = "HRM-Employee-List";
                }
                field("Employee-Male (PR)";"Employee-Male (PR)")
                {
                    ApplicationArea = Basic;
                    Caption = 'Employees - Male';
                    DrillDownPageID = "HRM-Employee-List";
                }
                field("Employee-Female (PR)";"Employee-Female (PR)")
                {
                    ApplicationArea = Basic;
                    Caption = 'Employees - Female';
                    DrillDownPageID = "HRM-Employee-List";
                }
                field(InactiveEmp;"Employee-InActive (PR)")
                {
                    ApplicationArea = Basic;
                    Caption = 'In-Active Employees';
                    DrillDownPageID = "HRM-Employee-List (Inactive)";
                }
            }
        }
    }

    actions
    {
Report "Individual Payslips mst";
Report "Company Payroll Summary";
Report "PRL-Deductions Summary 2";
Report "PRL-Payments Summary 2";
Report "Payroll Summary 2";
Report "PRL-Deductions Summary";
Report "PRL-Earnings Summary";
Report "Staff Pension Report";
Report prGrossNetPay;
Report "A third Rule Report";
Report "prCoop remmitance";
Page "FIN-Receipt Types";
Report "pr Transactions";
Report "pr Bank Schedule";
Report "Employer Certificate P.10 mst";
Report "P.10 A mst";
Report "prPaye Schedule mst";
Report "prNHIF mst";
Report "prNSSF mst";
Codeunit MailCodeunit ""
