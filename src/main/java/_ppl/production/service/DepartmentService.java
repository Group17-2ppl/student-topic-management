package _ppl.production.service;

import _ppl.production.entity.Department;

import java.util.List;
import java.util.Optional;

public interface DepartmentService {

    List<Department> findAll();

    Optional<Department> findById(Long id);

    Optional<Department> findByCode(String code);

    Optional<Department> findByName(String name);

    Department save(Department department);

    Department update(Long id, Department department);

    void deleteById(Long id);
}