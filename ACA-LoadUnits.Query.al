#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Query 50000 "ACA-Load Units"
{
    Caption = 'Units';
    OrderBy = ascending(Code),ascending(Programme_Code),ascending(Stage_Code);

    elements
    {
        dataitem(UnitsCourses;UnknownTable61517)
        {
            DataItemTableFilter = "Old Unit"=filter(No),"Time Table"=filter(Yes);
            Description = 'Units and Courses';
            column(Programme_Code;"Programme Code")
            {
            }
            column(Stage_Code;"Stage Code")
            {
            }
            column("Code";"Code")
            {
            }
            column(Desription;Desription)
            {
            }
        }
    }
}

