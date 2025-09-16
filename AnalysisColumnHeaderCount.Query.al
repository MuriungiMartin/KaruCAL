#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Query 771 "Analysis Column Header Count"
{
    Caption = 'Analysis Column Header Count';

    elements
    {
        dataitem(Analysis_Column;"Analysis Column")
        {
            column(Analysis_Area;"Analysis Area")
            {
            }
            column(Analysis_Column_Template;"Analysis Column Template")
            {
            }
            column(Column_Header;"Column Header")
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

