#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 90037 "FIN-Grade Medical Ceillings"
{
    Caption = 'Grade Medical Ceillings';
    PageType = List;
    SourceTable = UnknownTable61790;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Salary Grade code";"Salary Grade code")
                {
                    ApplicationArea = Basic;
                }
                field("In-Patient Medical Ceilling";"In-Patient Medical Ceilling")
                {
                    ApplicationArea = Basic;
                }
                field("Out-Patient Medical Ceilling";"Out-Patient Medical Ceilling")
                {
                    ApplicationArea = Basic;
                }
                field("Optical/Dental Ceiling";"Optical/Dental Ceiling")
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

