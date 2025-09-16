#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Query 770 "Analysis Line Desc. Count"
{
    Caption = 'Analysis Line Desc. Count';

    elements
    {
        dataitem(Analysis_Line;"Analysis Line")
        {
            column(Analysis_Area;"Analysis Area")
            {
            }
            column(Analysis_Line_Template_Name;"Analysis Line Template Name")
            {
            }
            column(Description;Description)
            {
            }
            column(Count_)
            {
                ColumnFilter = Count_=filter(>1);
                Method = Count;
            }
        }
    }
}

