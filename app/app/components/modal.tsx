import {
  PropsWithChildren,
  useState,
  forwardRef,
  useImperativeHandle,
} from "react";
import {
  Description,
  Dialog,
  DialogPanel,
  DialogTitle,
} from "@headlessui/react";

export default forwardRef(function Modal(
  {
    title,
    description,
    open,
    children: actions,
  }: PropsWithChildren<{ title: string; description: string; open: boolean }>,
  ref,
) {
  const [isOpen, setIsOpen] = useState(open);

  useImperativeHandle(ref, () => ({
    closeModal() {
      setIsOpen(false);
    },
  }));

  return (
    <Dialog
      open={isOpen}
      onClose={() => setIsOpen(false)}
      className="fixed inset-0 bg-gray-500/75 transition-opacity"
    >
      <div className="fixed inset-0 z-10 w-screen overflow-y-auto">
        <div className="flex min-h-full items-end justify-center p-4 text-center sm:items-center sm:p-0">
          <DialogPanel className="relative transform overflow-hidden rounded-lg bg-white text-left shadow-xl transition-all sm:my-8 sm:w-full sm:max-w-lg">
            <div className="bg-white px-4 pt-5 pb-4 sm:p-6 sm:pb-4">
              <div className="mt-3 text-center sm:mt-0 sm:ml-4 sm:text-left">
                <DialogTitle className="text-base font-semibold text-gray-900">
                  {title}
                </DialogTitle>
                <Description className="mt-2 text-sm text-gray-500">
                  {description}
                </Description>
              </div>
            </div>
            {actions && (
              <div className="bg-gray-50 px-4 py-3 sm:flex sm:flex-row-reverse sm:px-6">
                {actions}
              </div>
            )}
          </DialogPanel>
        </div>
      </div>
    </Dialog>
  );
});
