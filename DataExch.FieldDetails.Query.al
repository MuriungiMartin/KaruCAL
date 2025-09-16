#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Query 1232 "Data Exch. Field Details"
{
    Caption = 'Data Exch. Field Details';

    elements
    {
        dataitem(Data_Exch_Field;"Data Exch. Field")
        {
            SqlJoinType = InnerJoin;
            column(Line_No;"Line No.")
            {
            }
            column(Column_No;"Column No.")
            {
            }
            column(FieldValue;Value)
            {
            }
            column(Data_Exch_Line_Def_Code;"Data Exch. Line Def Code")
            {
            }
            column(Data_Exch_No;"Data Exch. No.")
            {
            }
            column(Node_ID;"Node ID")
            {
            }
            dataitem(Data_Exch;"Data Exch.")
            {
                DataItemLink = "Entry No."=Data_Exch_Field."Data Exch. No.";
                dataitem(Data_Exch_Column_Def;"Data Exch. Column Def")
                {
                    DataItemLink = "Column No."=Data_Exch_Field."Column No.","Data Exch. Def Code"=Data_Exch."Data Exch. Def Code","Data Exch. Line Def Code"=Data_Exch_Field."Data Exch. Line Def Code";
                    column(Name;Name)
                    {
                    }
                    column(Path;Path)
                    {
                    }
                    column(Negative_Sign_Identifier;"Negative-Sign Identifier")
                    {
                    }
                }
            }
        }
    }
}

