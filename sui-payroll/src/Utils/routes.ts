import DefaultRouter from 'next-routes';

const routes = new DefaultRouter();

routes.add('/employer', '/Employer');
routes.add('/employee', 'Employee');

export default routes;
