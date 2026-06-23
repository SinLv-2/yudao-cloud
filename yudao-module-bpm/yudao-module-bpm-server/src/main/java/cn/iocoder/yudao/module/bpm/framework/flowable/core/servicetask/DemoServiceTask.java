package cn.iocoder.yudao.module.bpm.framework.flowable.core.servicetask;

import lombok.extern.slf4j.Slf4j;
import org.flowable.bpmn.model.BpmnModel;
import org.flowable.bpmn.model.ExtensionElement;
import org.flowable.bpmn.model.FlowElement;
import org.flowable.bpmn.model.FlowNode;
import org.flowable.engine.ProcessEngines;
import org.flowable.engine.delegate.DelegateExecution;
import org.flowable.engine.delegate.JavaDelegate;
import org.springframework.stereotype.Component;

import java.util.Collection;
import java.util.List;
import java.util.Map;

//@Component
@Slf4j
public class DemoServiceTask implements JavaDelegate {
    @Override
    public void execute(DelegateExecution delegateExecution) {
        // 获取流程变量，这些变量是由流程配置的表单里的字段，在流程发起时设置的
        Map<String, Object> variables = delegateExecution.getVariables();
        log.info("DemoServiceTask 执行，variables：{}", variables);

        // 获取这个任务设置的扩展属性，在这个任务节点配置的
        getProperties(delegateExecution);

    }

    /**
     * 获取当前任务节点的扩展属性
     * @param delegateExecution 流程执行对象
     */
    public void getProperties(DelegateExecution delegateExecution) {
        // 获取当前活动节点
        String currentActivityId = delegateExecution.getCurrentActivityId();
        // 获取流程定义id
        String processDefinitionId = delegateExecution.getProcessDefinitionId();
        // 获取bpmn Model
        BpmnModel bpmnModel = ProcessEngines.getDefaultProcessEngine().getRepositoryService().getBpmnModel(processDefinitionId);
        // 获取当前节点
        FlowElement flowElement = bpmnModel.getFlowElement(currentActivityId);
        if (flowElement instanceof FlowNode) {
            List<ExtensionElement> properties =
                    flowElement.getExtensionElements().get("properties");

            if (properties != null) {
                for (ExtensionElement prop : properties) {
                    List<ExtensionElement> propertyList =
                            prop.getChildElements().get("property");

                    for (ExtensionElement p : propertyList) {
                        String name = p.getAttributeValue(null, "name");
                        String value = p.getAttributeValue(null, "value");

                        log.info("扩展属性property: {} = {}", name, value);
                    }
                }
            }
        }
    }
}
