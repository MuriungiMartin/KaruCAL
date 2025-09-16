#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68193 "HMS-Setups Management"
{
    Caption = 'Patient Documents View';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = UnknownTable61402;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Patient No.";"Patient No.")
                {
                    ApplicationArea = Basic;
                }
                field("Date Registered";"Date Registered")
                {
                    ApplicationArea = Basic;
                }
                field("Patient Type";"Patient Type")
                {
                    ApplicationArea = Basic;
                }
                field(Surname;Surname)
                {
                    ApplicationArea = Basic;
                }
                field("Middle Name";"Middle Name")
                {
                    ApplicationArea = Basic;
                }
                field("Last Name";"Last Name")
                {
                    ApplicationArea = Basic;
                }
                field(Gender;Gender)
                {
                    ApplicationArea = Basic;
                }
                field("Date Of Birth";"Date Of Birth")
                {
                    ApplicationArea = Basic;
                }
                field("Marital Status";"Marital Status")
                {
                    ApplicationArea = Basic;
                }
                field("ID Number";"ID Number")
                {
                    ApplicationArea = Basic;
                }
                field("Patient Ref. No.";"Patient Ref. No.")
                {
                    ApplicationArea = Basic;
                }
                field("Depandant Principle Member";"Depandant Principle Member")
                {
                    ApplicationArea = Basic;
                }
                field("Patient Current Location";"Patient Current Location")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            group("Setups Management")
            {
                Caption = 'Setups Management';
                Image = Setup;
                action("Setup Card")
                {
                    ApplicationArea = Basic;
                    Caption = 'Setup Card';
                    Image = SetupList;
                    Promoted = true;
                    RunObject = Page "HMS-Setup Card";
                }
                action("Systems Setup")
                {
                    ApplicationArea = Basic;
                    Caption = 'Systems Setup';
                    Image = SetupList;
                    Promoted = true;
                    RunObject = Page "HMS-Systems Card";
                }
                action(Doctors)
                {
                    ApplicationArea = Basic;
                    Caption = 'Doctors';
                    Image = SetupList;
                    Promoted = true;
                    RunObject = Page "HMS-Setup Doctor Card";
                }
                action("Blood Group")
                {
                    ApplicationArea = Basic;
                    Caption = 'Blood Group';
                    Image = SetupList;
                    Promoted = true;
                    RunObject = Page "HMS-Setup Blood Group Card";
                }
                action("Blood Group Donation")
                {
                    ApplicationArea = Basic;
                    Caption = 'Blood Group Donation';
                    Image = SetupList;
                    Promoted = true;
                    RunObject = Page "HMS-Blood Group Donation Card";
                }
                action("Drug Interaction")
                {
                    ApplicationArea = Basic;
                    Caption = 'Drug Interaction';
                    Image = SetupList;
                    Promoted = true;
                    RunObject = Page "HMS Drug Interaction Header";
                }
                action("Observation Signs")
                {
                    ApplicationArea = Basic;
                    Caption = 'Observation Signs';
                    Image = SetupList;
                    Promoted = true;
                    RunObject = Page "HMS Observation Signs";
                }
                action("Appointment Type")
                {
                    ApplicationArea = Basic;
                    Caption = 'Appointment Type';
                    Image = SetupList;
                    Promoted = true;
                    RunObject = Page "HMS-Setup Appointment Typ Card";
                }
                action("Triage Tests Setup")
                {
                    ApplicationArea = Basic;
                    Caption = 'Triage Tests Setup';
                    Image = SetupList;
                    Promoted = true;
                    RunObject = Page "CAT-Catering Ledger";
                }
                action("Vital Process")
                {
                    ApplicationArea = Basic;
                    Caption = 'Vital Process';
                    Image = SetupList;
                    Promoted = true;
                    RunObject = Page "HMS-Setup Process Card";
                }
                action(Injection)
                {
                    ApplicationArea = Basic;
                    Caption = 'Injection';
                    Image = SetupList;
                    Promoted = true;
                    RunObject = Page "HMS-Setup Injection Card";
                }
                action(Diagnosis)
                {
                    ApplicationArea = Basic;
                    Caption = 'Diagnosis';
                    Image = SetupList;
                    Promoted = true;
                    RunObject = Page "HMS-Setup Diagnosis Card";
                }
                action(Immunization)
                {
                    ApplicationArea = Basic;
                    Caption = 'Immunization';
                    Image = SetupList;
                    Promoted = true;
                    RunObject = Page "ACA-Immunization Card";
                }
                action(Allergy)
                {
                    ApplicationArea = Basic;
                    Caption = 'Allergy';
                    Image = SetupList;
                    Promoted = true;
                    RunObject = Page "HMS-Setup Allergy Card";
                }
                action(Signs)
                {
                    ApplicationArea = Basic;
                    Caption = 'Signs';
                    Image = SetupList;
                    Promoted = true;
                    RunObject = Page "HMS Signs";
                }
                action(Syptoms)
                {
                    ApplicationArea = Basic;
                    Caption = 'Syptoms';
                    Image = SetupList;
                    Promoted = true;
                    RunObject = Page "HMS Syptoms";
                }
                action("Patient History")
                {
                    ApplicationArea = Basic;
                    Caption = 'Patient History';
                    Image = SetupList;
                    Promoted = true;
                    RunObject = Page "HMS Patient History";
                }
                action("Measuring Unit(s)")
                {
                    ApplicationArea = Basic;
                    Caption = 'Measuring Unit(s)';
                    Image = SetupList;
                    Promoted = true;
                    RunObject = Page "HMS-Setup Measuring Unit Card";
                }
                action(Specimen)
                {
                    ApplicationArea = Basic;
                    Caption = 'Specimen';
                    Image = SetupList;
                    Promoted = true;
                    RunObject = Page "HMS-Setup Specimen Card";
                }
                action("Laboratory Tests")
                {
                    ApplicationArea = Basic;
                    Caption = 'Laboratory Tests';
                    Image = SetupList;
                    Promoted = true;
                    RunObject = Page "HMS-Setup Lab Test Card";
                }
                action("Radiology Type")
                {
                    ApplicationArea = Basic;
                    Caption = 'Radiology Type';
                    Image = SetupList;
                    Promoted = true;
                    RunObject = Page "HMS-Setup Radiology Type Card";
                }
                action("Admission Discharge Process")
                {
                    ApplicationArea = Basic;
                    Caption = 'Admission Discharge Process';
                    Image = SetupList;
                    Promoted = true;
                    RunObject = Page "HMS Setup Disctarge Process";
                }
                action("Ward Setup")
                {
                    ApplicationArea = Basic;
                    Caption = 'Ward Setup';
                    Image = SetupList;
                    Promoted = true;
                    RunObject = Page "HMS ward Setup";
                }
                action(Beds)
                {
                    ApplicationArea = Basic;
                    Caption = 'Beds';
                    Image = SetupList;
                    Promoted = true;
                    RunObject = Page "HMS Beds";
                }
                action(Charges)
                {
                    ApplicationArea = Basic;
                    Caption = 'Charges';
                    Image = SetupPayment;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "HMS-Hospital Charges Setup";
                }
            }
        }
    }
}

