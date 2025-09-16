#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69099 "HRM-Auto_Inreament Sal. Steps"
{
    Caption = 'Salary Steps Per Grade';
    DataCaptionFields = "Employee Category","Salary Grade",Step;
    Description = 'Salary Steps Per Grade';
    PageType = List;
    SourceTable = UnknownTable61793;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Step;Step)
                {
                    ApplicationArea = Basic;
                }
                field("Basic Salary";"Basic Salary")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }
}

