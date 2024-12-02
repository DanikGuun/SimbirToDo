
import UIKit

class TaskEditCellFabric{
    
    class func create(for indexPath: IndexPath) -> TaskEditCell?{
        switch self.getTypeByIndexPath(indexPath){
        case .name: return TaskNameCell()
        case .description: return TaskDescriptionCell()
        case .date: return TaskDateCell()
        default: return nil
        }
    }
    
    private class func getTypeByIndexPath(_ indexPath: IndexPath) -> EditCellType?{
        switch indexPath.section{
        case 0:
            switch indexPath.row{
            case 0: return .name
            case 1: return .date
            case 2: return .description
            default: return nil
            }
        default: return nil
        }
    }
    
    private enum EditCellType{
        case name
        case date
        case description
    }
}


