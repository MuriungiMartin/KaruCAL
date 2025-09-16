#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 70076 "Proc-Preq. Suppliers/Category"
{
    PageType = ListPart;
    SourceTable = UnknownTable60226;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Preq. Year";"Preq. Year")
                {
                    ApplicationArea = Basic;
                    Enabled = false;
                }
                field("Preq. Category";"Preq. Category")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field(Supplier_Code;Supplier_Code)
                {
                    ApplicationArea = Basic;
                }
                field("Supplier Name";"Supplier Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field(Phone;Phone)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field(Email;Email)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("RQS Placed";"RQS Placed")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Quotes Received";"Quotes Received")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("LPOs Placed";"LPOs Placed")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }
}

