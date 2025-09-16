#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Query 763 "Colm. Layt. Colm. Header Count"
{
    Caption = 'Colm. Layt. Colm. Header Count';

    elements
    {
        dataitem(Column_Layout;"Column Layout")
        {
            column(Column_Layout_Name;"Column Layout Name")
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

