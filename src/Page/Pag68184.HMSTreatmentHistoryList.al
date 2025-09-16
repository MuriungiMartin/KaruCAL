#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68184 "HMS-Treatment History List"
{
    CardPageID = "HMS Treatment Form History";
    Editable = false;
    PageType = List;
    SourceTable = UnknownTable61407;
    SourceTableView = where(Status=const(Completed));

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                Editable = false;
                field("Treatment No.";"Treatment No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Treatment No.';
                }
                field("Treatment Location";"Treatment Location")
                {
                    ApplicationArea = Basic;
                }
                field("Treatment Type";"Treatment Type")
                {
                    ApplicationArea = Basic;
                }
                field(Direct;Direct)
                {
                    ApplicationArea = Basic;
                }
                field("Link No.";"Link No.")
                {
                    ApplicationArea = Basic;
                }
                field("Treatment Date";"Treatment Date")
                {
                    ApplicationArea = Basic;
                }
                field("Treatment Time";"Treatment Time")
                {
                    ApplicationArea = Basic;
                }
                field("Doctor ID";"Doctor ID")
                {
                    ApplicationArea = Basic;
                }
                field("Patient No.";"Patient No.")
                {
                    ApplicationArea = Basic;
                }
                field("Student No.";"Student No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Student/Emp/Rel No.';
                    Editable = false;
                }
                field("Treatment Remarks";"Treatment Remarks")
                {
                    ApplicationArea = Basic;
                }
                field("Employee No.";"Employee No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'PF No.';
                    Editable = false;
                }
                field("Employee No.2";"Employee No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Relative No.";"Relative No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            group("&Treatment Details")
            {
                Caption = '&Treatment Details';
                Image = Ledger;
                action(Processes)
                {
                    ApplicationArea = Basic;
                    Caption = 'Processes';
                    Image = Production;
                    Promoted = true;
                    RunObject = Page "HMS-Treatment Form Processes";
                    RunPageLink = "Treatment No."=field("Treatment No.");
                }
                action(Signs)
                {
                    ApplicationArea = Basic;
                    Caption = 'Signs';
                    Image = RegisteredDocs;
                    Promoted = true;
                    RunObject = Page "HMS Observation Signs";
                    RunPageLink = "Treatment No."=field("Treatment No.");
                }
                action(Symptoms)
                {
                    ApplicationArea = Basic;
                    Caption = 'Symptoms';
                    Image = RegisterPick;
                    Promoted = true;
                    RunObject = Page "HMS Observation Symptoms";
                    RunPageLink = "Treatment No."=field("Treatment No.");
                }
                action(History)
                {
                    ApplicationArea = Basic;
                    Caption = 'History';
                    Image = History;
                    Promoted = true;
                    RunObject = Page "HMS Treatment History";
                    RunPageLink = "Treatment No."=field("Treatment No.");
                }
                action("Laboratory Needs")
                {
                    ApplicationArea = Basic;
                    Caption = 'Laboratory Needs';
                    Image = TestFile;
                    Promoted = true;
                    RunObject = Page "HMS-Treatment Form Laboratory";
                    RunPageLink = "Treatment No."=field("Treatment No.");
                }
                action("Radiology Needs")
                {
                    ApplicationArea = Basic;
                    Caption = 'Radiology Needs';
                    Image = ReleaseShipment;
                    Promoted = true;
                    RunObject = Page "HMS-Treatment Form Radiology";
                    RunPageLink = "Treatment No."=field("Treatment No.");
                }
                action(Diagmnosis)
                {
                    ApplicationArea = Basic;
                    Caption = 'Diagmnosis';
                    Image = AnalysisView;
                    Promoted = true;
                    RunObject = Page "HMS-Treatment Form Diagnosis";
                    RunPageLink = "Treatment No."=field("Treatment No.");
                }
                action(Injections)
                {
                    ApplicationArea = Basic;
                    Caption = 'Injections';
                    Image = Reconcile;
                    Promoted = true;
                    RunObject = Page "HMS-Treatment Form Injection";
                    RunPageLink = "Treatment No."=field("Treatment No.");
                }
                action(Prescriptions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Prescriptions';
                    Image = ItemAvailability;
                    Promoted = true;
                    RunObject = Page "HMS-Treatment Form Drug";
                    RunPageLink = "Treatment No."=field("Treatment No.");
                }
                action(Referrals)
                {
                    ApplicationArea = Basic;
                    Caption = 'Referrals';
                    Image = Reconcile;
                    Promoted = true;
                    RunObject = Page "HMS-Treatment Form Referral";
                    RunPageLink = "Treatment No."=field("Treatment No.");
                }
                action(Admissions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Admissions';
                    Image = Account;
                    Promoted = true;
                    RunObject = Page "HMS-Treatment Form Admission";
                    RunPageLink = "Treatment No."=field("Treatment No.");
                }
            }
        }
    }

    trigger OnInit()
    begin
        CurrPage.LookupMode := true;
    end;
}

