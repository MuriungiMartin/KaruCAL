#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68782 "ACA-Student Aluminae"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Document;
    SourceTable = Customer;
    SourceTableView = where("Customer Type"=const(Student),
                            Status=filter(Alumni|"Dropped Out"|Suspended|Expulsion|Discontinued|Deceased|Transferred));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                }
                field("ID No";"ID No")
                {
                    ApplicationArea = Basic;
                }
                field("Date Registered";"Date Registered")
                {
                    ApplicationArea = Basic;
                }
                field("Payments By";"Payments By")
                {
                    ApplicationArea = Basic;
                }
                field("Membership No";"Membership No")
                {
                    ApplicationArea = Basic;
                }
                field(Citizenship;Citizenship)
                {
                    ApplicationArea = Basic;
                }
                field(sms_Password;sms_Password)
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
                field(Religion;Religion)
                {
                    ApplicationArea = Basic;
                    Caption = 'Religion';
                }
                field("Customer Posting Group";"Customer Posting Group")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posting Group';
                }
                field("Gen. Bus. Posting Group";"Gen. Bus. Posting Group")
                {
                    ApplicationArea = Basic;
                }
                field("VAT Bus. Posting Group";"VAT Bus. Posting Group")
                {
                    ApplicationArea = Basic;
                }
                field(Blocked;Blocked)
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Picture;Picture)
                {
                    ApplicationArea = Basic;
                }
            }
            group("Next Of Kin")
            {
                Caption = 'Next Of Kin';
                part(Control1000000020;"ACA-Student Kin")
                {
                    SubPageLink = "Student No"=field("No.");
                }
            }
            group("Education History")
            {
                Caption = 'Education History';
                part(Control1000000056;"ACA-Student Education History")
                {
                    SubPageLink = "Student No."=field("No.");
                }
            }
            group(Comments)
            {
                Caption = 'Comments';
                part(Control1000000057;"ACA-Student Comments")
                {
                    SubPageLink = "Student No."=field("No.");
                }
            }
            group("Contact Details")
            {
                Caption = 'Contact Details';
                field(Address;Address)
                {
                    ApplicationArea = Basic;
                }
                field("Address 2";"Address 2")
                {
                    ApplicationArea = Basic;
                }
                field("Post Code";"Post Code")
                {
                    ApplicationArea = Basic;
                }
                field(City;City)
                {
                    ApplicationArea = Basic;
                }
                field("Country/Region Code";"Country/Region Code")
                {
                    ApplicationArea = Basic;
                }
                field("Phone No.";"Phone No.")
                {
                    ApplicationArea = Basic;
                }
                field("Telex No.";"Telex No.")
                {
                    ApplicationArea = Basic;
                }
                field("Fax No.";"Fax No.")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Sponsor)
            {
                Caption = 'Sponsor';
                field("Bill-to Customer No.";"Bill-to Customer No.")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Student)
            {
                Caption = 'Student';
                action("Registration Details")
                {
                    ApplicationArea = Basic;
                    Caption = 'Registration Details';
                    RunObject = Page "ACA-Student Registration";
                    RunPageLink = "No."=field("No.");
                }
                action("Re-Activate Record")
                {
                    ApplicationArea = Basic;
                    Caption = 'Re-Activate Record';

                    trigger OnAction()
                    begin
                        if Confirm('Are you sure you want to re-activate student?',true) = true then begin
                        Status:=Status::Current;
                        Modify;
                        end;
                    end;
                }
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        "Customer Type":="customer type"::Student;
    end;

    var
        PictureExists: Boolean;
}

