#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 99422 "NEW SPOS Rolecenter"
{
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            part(Control1000000001;"POS Menu List")
            {
            }
        }
    }

    actions
    {
        area(sections)
        {
        }
Page "POS Setup";
                Visible = false;
Page "POS Sales Student Card";
                RunPageMode = Create;
                ShortCutKey = 'F9';
                Visible = false;
Page "POS Sales Staff";
                RunPageMode = Create;
                ShortCutKey = 'F7';
                Visible = false;
Report "POS cashier Sales Report";
Report "POS Daily Totals";
Report "POS Daily Totals General";
Report "Sales Per Item Summary";
                Visible = false;
Report "Sales Per Item Summary2";
                Visible = false;
Report "Sales Per Item Summary Two";
Report "FIN-Bank Ledger Summary/User";
Page "Approval Entries";
Page "Approval Request Entries";
Page "ACA-Clearance Approval Entries";
Page "PROC-Store Requisition";
Page "FIN-Imprest List UP";
Page "HRM-Leave Requisition List";
Page "HRM-My Approved Leaves List";
Page ""CAT;""

