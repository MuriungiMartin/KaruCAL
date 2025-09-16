#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69183 "REG-File Requisition List"
{
    CardPageID = "REG-File Requisition";
    PageType = List;
    SourceTable = UnknownTable61638;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No;No)
                {
                    ApplicationArea = Basic;
                }
                field(Date;Date)
                {
                    ApplicationArea = Basic;
                }
                field("Requesting Officer";"Requesting Officer")
                {
                    ApplicationArea = Basic;
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                }
                field(Designation;Designation)
                {
                    ApplicationArea = Basic;
                }
                field("Collecting Officer";"Collecting Officer")
                {
                    ApplicationArea = Basic;
                }
                field(Purpose;Purpose)
                {
                    ApplicationArea = Basic;
                }
                field("File No";"File No")
                {
                    ApplicationArea = Basic;
                }
                field("File Name";"File Name")
                {
                    ApplicationArea = Basic;
                }
                field("Authorized By";"Authorized By")
                {
                    ApplicationArea = Basic;
                }
                field("Served By";"Served By")
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

