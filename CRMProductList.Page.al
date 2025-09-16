#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5348 "CRM Product List"
{
    ApplicationArea = Basic;
    Caption = 'Microsoft Dynamics CRM Products';
    Editable = false;
    PageType = List;
    SourceTable = "CRM Product";
    SourceTableView = sorting(ProductNumber);
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                field(ProductNumber;ProductNumber)
                {
                    ApplicationArea = Suite;
                    Caption = 'Product Number';
                    StyleExpr = FirstColumnStyle;
                }
                field(Name;Name)
                {
                    ApplicationArea = Suite;
                    Caption = 'Name';
                    ToolTip = 'Specifies the name of the record.';
                }
                field(Price;Price)
                {
                    ApplicationArea = Suite;
                    Caption = 'Price';
                }
                field(StandardCost;StandardCost)
                {
                    ApplicationArea = Suite;
                    Caption = 'Standard Cost';
                }
                field(CurrentCost;CurrentCost)
                {
                    ApplicationArea = Suite;
                    Caption = 'Current Cost';
                    ToolTip = 'Specifies the item''s unit cost.';
                }
                field(Coupled;Coupled)
                {
                    ApplicationArea = Suite;
                    Caption = 'Coupled';
                    ToolTip = 'Specifies if the Dynamics CRM record is coupled to Dynamics NAV.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    var
        CRMIntegrationRecord: Record "CRM Integration Record";
        RecordID: RecordID;
    begin
        if CRMIntegrationRecord.FindRecordIDFromID(ProductId,Database::Item,RecordID) or
           CRMIntegrationRecord.FindRecordIDFromID(ProductId,Database::Resource,RecordID)
        then
          if CurrentlyCoupledCRMProduct.ProductId = ProductId then begin
            Coupled := 'Current';
            FirstColumnStyle := 'Strong';
          end else begin
            Coupled := 'Yes';
            FirstColumnStyle := 'Subordinate';
          end
        else begin
          Coupled := 'No';
          FirstColumnStyle := 'None';
        end;
    end;

    trigger OnInit()
    begin
        Codeunit.Run(Codeunit::"CRM Integration Management");
    end;

    var
        CurrentlyCoupledCRMProduct: Record "CRM Product";
        Coupled: Text;
        FirstColumnStyle: Text;


    procedure SetCurrentlyCoupledCRMProduct(CRMProduct: Record "CRM Product")
    begin
        CurrentlyCoupledCRMProduct := CRMProduct;
    end;
}

