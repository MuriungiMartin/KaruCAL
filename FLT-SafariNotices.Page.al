#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69129 "FLT-Safari Notices"
{
    PageType = Document;
    SourceTable = UnknownTable61807;
    SourceTableView = where(Status=filter(<>Submitted));

    layout
    {
        area(content)
        {
            group("Employee Safari Notices")
            {
                field("Safari No.";"Safari No.")
                {
                    ApplicationArea = Basic;
                }
                field("Proposed By";"Proposed By")
                {
                    ApplicationArea = Basic;
                }
                field("Proposer Name";"Proposer Name")
                {
                    ApplicationArea = Basic;
                }
                field("Proposer Department";"Proposer Department")
                {
                    ApplicationArea = Basic;
                }
                field("Proposed Date";"Proposed Date")
                {
                    ApplicationArea = Basic;
                }
                field("Officer Going";"Officer Going")
                {
                    ApplicationArea = Basic;
                }
                field("Officer Going Name";"Officer Going Name")
                {
                    ApplicationArea = Basic;
                }
                field("Officer Designation";"Officer Designation")
                {
                    ApplicationArea = Basic;
                }
                field("Purpose Of Visit";"Purpose Of Visit")
                {
                    ApplicationArea = Basic;
                }
                field("Place to Visit";"Place to Visit")
                {
                    ApplicationArea = Basic;
                }
                field("Departure Date";"Departure Date")
                {
                    ApplicationArea = Basic;
                }
                field("Return Date";"Return Date")
                {
                    ApplicationArea = Basic;
                }
                field("Departure Mileage";"Departure Mileage")
                {
                    ApplicationArea = Basic;
                }
                field("Reg. No";"Reg. No")
                {
                    ApplicationArea = Basic;
                }
                field(Make;Make)
                {
                    ApplicationArea = Basic;
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                }
                field("Estimated Cost of Safari";"Estimated Cost of Safari")
                {
                    ApplicationArea = Basic;
                }
                field(Dept;Dept)
                {
                    ApplicationArea = Basic;
                }
                field("T.O. Name";"T.O. Name")
                {
                    ApplicationArea = Basic;
                }
                field("T.O. Approval Date";"T.O. Approval Date")
                {
                    ApplicationArea = Basic;
                }
                field(Makes;Makes)
                {
                    ApplicationArea = Basic;
                }
                field(Model;Model)
                {
                    ApplicationArea = Basic;
                }
            }
            part(Control25;"FLT-Officers Going on Safari")
            {
                Caption = 'Officers Going on Safari';
                SubPageLink = "Safari No."=field("Safari No.");
            }
        }
    }

    actions
    {
    }
}

