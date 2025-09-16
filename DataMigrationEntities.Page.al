#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1810 "Data Migration Entities"
{
    Caption = 'Data Migration Entities';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = "Data Migration Entity";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Selected;Selected)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies whether the table will be migrated. If the check box is selected, then the table will be migrated.';
                }
                field("Table Name";"Table Name")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the name of the table to be migrated.';
                }
                field("No. of Records";"No. of Records")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number of records in the table to be migrated.';
                }
            }
        }
    }

    actions
    {
    }


    procedure CopyToSourceTable(var TempDataMigrationEntity: Record "Data Migration Entity" temporary)
    begin
        DeleteAll;

        if TempDataMigrationEntity.FindSet then
          repeat
            Init;
            TransferFields(TempDataMigrationEntity);
            Insert;
          until TempDataMigrationEntity.Next = 0;
    end;


    procedure CopyFromSourceTable(var TempDataMigrationEntity: Record "Data Migration Entity" temporary)
    begin
        TempDataMigrationEntity.DeleteAll;

        if FindSet then
          repeat
            TempDataMigrationEntity.Init;
            TempDataMigrationEntity.TransferFields(Rec);
            TempDataMigrationEntity.Insert;
          until Next = 0;
    end;
}

