#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 78123 "FINPOS Rolecenter"
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
Page "POS Setup";
Page "POS Sales Student Card";
                RunPageMode = Create;
                ShortCutKey = 'F9';
Page "POS Sales Staff";
                RunPageMode = Create;
                ShortCutKey = 'F7';
Report "POS cashier Sales Report";
Report "POS Daily Totals";
Report "Sales Per Item Summary";
                Visible = false;
Report "Sales Per Item Summary2";
                Visible = false;
Report ""Sales ;""

