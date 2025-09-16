#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68654 "HMS Observation Symptoms"
{
    PageType = ListPart;
    SourceTable = UnknownTable61445;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field(System;System)
                {
                    ApplicationArea = Basic;
                }
                field("Symptom Code";"Symptom Code")
                {
                    ApplicationArea = Basic;
                }
                field("Symptom Description";"Symptom Description")
                {
                    ApplicationArea = Basic;
                }
                field(Duration;Duration)
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field(Characteristics;Characteristics)
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

