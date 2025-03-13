export type User = {
  name: string;
  email: string;
};

export type Session = {
  isAuth: boolean;
  user?: User;
};
