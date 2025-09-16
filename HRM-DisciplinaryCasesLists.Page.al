#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69011 "HRM-Disciplinary Cases Lists"
{
    CardPageID = "HRM-Disciplinary Case Card";
    Editable = false;
    PageType = List;
    SourceTable = UnknownTable61223;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Case Number";"Case Number")
                {
                    ApplicationArea = Basic;
                }
                field("Date of Complaint";"Date of Complaint")
                {
                    ApplicationArea = Basic;
                }
                field("Type Complaint";"Type Complaint")
                {
                    ApplicationArea = Basic;
                }
                field("Recommended Action";"Recommended Action")
                {
                    ApplicationArea = Basic;
                }
                field("Description of Complaint";"Description of Complaint")
                {
                    ApplicationArea = Basic;
                }
                field(Accuser;Accuser)
                {
                    ApplicationArea = Basic;
                }
                field("Witness #1";"Witness #1")
                {
                    ApplicationArea = Basic;
                }
                field("Witness #2";"Witness #2")
                {
                    ApplicationArea = Basic;
                }
                field("Action Taken";"Action Taken")
                {
                    ApplicationArea = Basic;
                }
                field("Date To Discuss Case";"Date To Discuss Case")
                {
                    ApplicationArea = Basic;
                }
                field("Disciplinary Remarks";"Disciplinary Remarks")
                {
                    ApplicationArea = Basic;
                }
                field(Comments;Comments)
                {
                    ApplicationArea = Basic;
                }
                field("Case Discussion";"Case Discussion")
                {
                    ApplicationArea = Basic;
                }
                field("Body Handling The Complaint";"Body Handling The Complaint")
                {
                    ApplicationArea = Basic;
                }
                field(Recomendations;Recomendations)
                {
                    ApplicationArea = Basic;
                }
                field("HR/Payroll Implications";"HR/Payroll Implications")
                {
                    ApplicationArea = Basic;
                }
                field("Policy Guidlines In Effect";"Policy Guidlines In Effect")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
                field("Mode of Lodging the Complaint";"Mode of Lodging the Complaint")
                {
                    ApplicationArea = Basic;
                }
                field("Accused Employee";"Accused Employee")
                {
                    ApplicationArea = Basic;
                }
                field(Selected;Selected)
                {
                    ApplicationArea = Basic;
                }
                field("Closed By";"Closed By")
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

