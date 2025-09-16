#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68010 "ACA-Admitted Applicants List"
{
    CardPageID = "ACA-Applications Card 3";
    DelayedInsert = false;
    DeleteAllowed = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = UnknownTable61372;
    SourceTableView = where(Status=filter("Doc. Verification"));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Admission No.";"Admission No.")
                {
                    ApplicationArea = Basic;
                }
                field(Date;Date)
                {
                    ApplicationArea = Basic;
                }
                field("Application No.";"Application No.")
                {
                    ApplicationArea = Basic;
                }
                field(Surname;Surname)
                {
                    ApplicationArea = Basic;
                }
                field("Other Names";"Other Names")
                {
                    ApplicationArea = Basic;
                }
                field("Faculty Admitted To";"Faculty Admitted To")
                {
                    ApplicationArea = Basic;
                }
                field("Degree Admitted To";"Degree Admitted To")
                {
                    ApplicationArea = Basic;
                }
                field("Correspondence Address 1";"Correspondence Address 1")
                {
                    ApplicationArea = Basic;
                }
                field("Telephone No. 1";"Telephone No. 1")
                {
                    ApplicationArea = Basic;
                }
                field("Fax No.";"Fax No.")
                {
                    ApplicationArea = Basic;
                }
                field("E-Mail";"E-Mail")
                {
                    ApplicationArea = Basic;
                }
                field("ID Number";"ID Number")
                {
                    ApplicationArea = Basic;
                }
                field("Settlement Type";"Settlement Type")
                {
                    ApplicationArea = Basic;
                }
                field("Intake Code";"Intake Code")
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

